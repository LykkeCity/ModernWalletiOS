//
//  SignInPasswordFormController.swift
//  ModernMoney
//
//  Created by Nacho Nachev on 28.11.17.
//  Copyright © 2017 Lykkex. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import WalletCore

class SignInPasswordFormController: RecoveryController {
    
    let email: String
    
    init(email: String) {
        self.email = email
    }
    
    lazy var formViews: [UIView] = {
        return [
            self.titleLabel(title: self.email),
            self.passwordTextField,
            self.forgottenPasswordView
        ]
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = self.textField(placeholder: Localize("auth.newDesign.password"))
        textField.isSecureTextEntry = true
        textField.returnKeyType = .next
        return textField
    }()
    
    private lazy var forgottenPasswordView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        let button = self.forgottenPasswordTextButton
        view.addSubview(button)
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 60.0))
        view.addConstraint(NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 20.0))
        view.addConstraint(NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        return view
    }()
    
    private lazy var forgottenPasswordTextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localize("auth.newDesign.forgottenPassword"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Geomanist", size: 14.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return button
    }()

    
    var canGoBack: Bool {
        return true
    }
    
    var buttonTitle: String? {
        return Localize("auth.newDesign.signin")
    }
    
    private var needToFill: LogInViewModel.NeedToFill? = nil
    
    var next: FormController? {
        return needToFill.asController(email: self.email)
    }
    
    var recoveryStep: RecoveryController? {
        return RecoverySeedWordsFormController(email: self.email)
    }
    
    var segueIdentifier: String? {
        if self.needToFill?.isPin() ?? false {
            return "CreateKey"
        }
        
        return nil
    }
    
    
    
    private var pinViewController: PinViewController {
        if self.needToFill?.isPin() ?? false {
            return PinViewController.createPinViewControllerWithoutCloseButton
        }
        
        return PinViewController.enterPinViewController(title: Localize("auth.newDesign.enterPin"), isTouchIdEnabled: false)
    }
    
    private var loginTrigger = PublishSubject<Void>()
    
    private lazy var loginViewModel: LogInViewModel = {
        let viewModel = LogInViewModel(submit: self.loginTrigger.asObservable())
        viewModel.email.value = self.email
        return viewModel
    }()
    
    private var disposeBag = DisposeBag()
    
    func bind<T>(button: UIButton,
                 nextTrigger: PublishSubject<Void>,
                 recoveryTrigger: PublishSubject<Void>,
                 recoveryPinTrigger: PublishSubject<String>,
                 pinTrigger: PublishSubject<PinViewController?>,
                 loading: UIBindingObserver<T, Bool>,
                 error: UIBindingObserver<T, [AnyHashable : Any]>,
                 toast: UIBindingObserver<T, String>) where T : UIViewController {
        disposeBag = DisposeBag()
        
        passwordTextField.rx.returnTap
            .bind(to: loginTrigger)
            .disposed(by: disposeBag)
        
        loginTrigger
            .bindToResignFirstResponder(views: formViews)
            .disposed(by: disposeBag)
        
        button.rx.tap
            .bind(to: loginTrigger)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.asObservable()
            .filterNil()
            .bind(to: loginViewModel.password)
            .disposed(by: disposeBag)
        
        forgottenPasswordTextButton.rx.tap
            .throttle(1, scheduler: MainScheduler.instance)
            .bind(to: recoveryTrigger)
            .disposed(by: disposeBag)

        loginViewModel.result.asObservable().filterError()
            .bind(to: error)
            .disposed(by: disposeBag)
        
        let needToFillDriver = loginViewModel.needToFill
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .do(onNext: { [weak self]  in self?.needToFill = $0 })
            .shareReplay(1)
        
        let pinViewControllerObservable = Observable
            .merge(
                needToFillDriver
                    .filter{ $0.isPin() }
                    .map{ _ in () },
                loginViewModel.showPinViewController.asObservable()
            )
            .map{ [weak self] in return self?.pinViewController }
            .filterNil()
            .shareReplay(1)
        
        let pinResult = pinViewControllerObservable
            .flatMap { $0.complete }
            .shareReplay(1)
            
        pinViewControllerObservable
            .bind(to: pinTrigger)
            .disposed(by: disposeBag)
        
        loginViewModel.loading
            .bind(to: loading)
            .disposed(by: disposeBag)
        
        loginViewModel.result.asObservable().filterError()
            .bind(to: error)
            .disposed(by: disposeBag)

        let needToFill = needToFillDriver
            .filter{ !$0.isPin() }
            .map{ _ in () }
            .waitFor(loginViewModel.loading)
            .shareReplay(1)
        
        let pinSucceded = pinResult
            .filter{ $0 }
            .map{ _ in () }
            .shareReplay(1)
        
        Observable
            .merge(needToFill, pinSucceded)
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: nextTrigger)
            .disposed(by: disposeBag)
        
        loginViewModel.isValid
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func unbind() {
        disposeBag = DisposeBag()
    }
}
    
extension Observable where Element == Void {
    
    func bindToResignFirstResponder(views: [UIView]) -> Disposable {
        return bind(onNext: {
            for view in views {
                view.resignFirstResponder()
            }
        })
    }
    
}


fileprivate extension Optional where Wrapped == LogInViewModel.NeedToFill {
    
    func asController(email: String) -> FormController? {
        guard let needToFill = self else {
            return SignInPhoneVerificationFormController(phone: LWKeychainManager.instance()?.personalData()?.phone ?? "", email: email)
        }
        
        let email = LWKeychainManager.instance()?.personalData()?.email ?? ""
        
        switch needToFill {
        case .fullName:
            return SignUpFillProfileFormController(email: email)
            
        case .phone:
            return SignUpFillPhoneFormController(email: email)
            
        case .pin:
            return nil // look at segueIdentifier
        }
    }
}
