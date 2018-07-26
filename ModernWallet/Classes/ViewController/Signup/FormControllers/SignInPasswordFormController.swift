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

class SignInPasswordFormController: FormController {

    let email: String

    init(email: String) {
        self.email = email
    }

    lazy var formViews: [UIView] = {
        return [
            self.titleLabel(title: self.email),
            self.passwordTextField
        ]
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = self.textField(placeholder: Localize("auth.newDesign.password"))
        textField.isSecureTextEntry = true
        textField.returnKeyType = .next
        return textField
    }()

    var canGoBack: Bool {
        return true
    }

    var buttonTitle: String? {
        return Localize("auth.newDesign.signin")
    }

    var next: FormController? {
        return SignInConfirmPhoneFormController(signIn: true, phone: LWKeychainManager.instance()?.personalData()?.phone ?? "")
    }

    var segueIdentifier: String? {
        return nil
    }

    private var pinViewController: PinViewController {
        return PinViewController.enterPinViewController(title: Localize("auth.newDesign.enterPin"), isTouchIdEnabled: false)
    }

    private var loginTrigger = PublishSubject<Void>()

    private lazy var loginViewModel: LogInViewModel = {
        let viewModel = LogInViewModel(submit: self.loginTrigger.asObservable())
        viewModel.email.value = self.email
        return viewModel
    }()

    private var disposeBag = DisposeBag()

    func bind<T: UIViewController>(button: UIButton, nextTrigger: PublishSubject<Void>, pinTrigger: PublishSubject<PinViewController?>, loading: UIBindingObserver<T, Bool>, error: UIBindingObserver<T, [AnyHashable: Any]>) {
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

        loginViewModel.result.asObservable().filterError()
            .bind(to: error)
            .disposed(by: disposeBag)

        let pinViewControllerObservable = loginViewModel.result.asObservable().filterSuccess()
            .map { _ in return self.pinViewController }
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

        pinResult
            .filter { $0 }
            .map { _ in () }
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
