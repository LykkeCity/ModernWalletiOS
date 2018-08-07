//
//  ChangePasswordViewController.swift
//  ModernMoney
//
//  Created by Vladimir Dimov on 24.07.18.
//  Copyright © 2018 Lykkex. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import WalletCore

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var passwordTextField: LimitedHoshiTextField!
    @IBOutlet weak var cofirmPasswordTextField: LimitedHoshiTextField!
    @IBOutlet private weak var confirmButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    /// Object to store the required recovery data
    var recoveryModel = LWRecoveryPasswordModel()
    
    /// Change password viewModel
    lazy var viewModel : ChangePasswordViewModel = {
        return ChangePasswordViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView?.subscribeKeyBoard(withDisposeBag: disposeBag)
        scrollView?.keyboardDismissMode = .onDrag
        
        passwordTextField.rx.text
            .filterNil()
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
//        passwordTextField.rx.returnTap
//            .subscribe(onNext: { [weak self] isConfirmed in
//                guard let strongSelf = self else { return }
//                strongSelf.cofirmPasswordTextField.becomeFirstResponder()
//            })
//            .disposed(by: disposeBag)
        
        cofirmPasswordTextField.rx.text
            .filterNil()
            .bind(to: viewModel.confirmPassword)
            .disposed(by: disposeBag)
        
//        cofirmPasswordTextField.rx.returnTap
//            .withLatestFrom(viewModel.isValid.asObservable())
//            .filterTrueAndBind(toTrigger: nextTrigger)
//            .disposed(by: disposeBag)
        
        viewModel.isValid
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .flatMapLatest { [weak self]  _ -> Observable<(complete: Bool, pin: String)> in
                guard let strongSelf = self else { return .never() }
                return PinViewController.presentResetPinController(from: strongSelf, title: "Hello world")
            }
            .filter { $0.complete }
            .subscribe(onNext: { [weak self] value in
                guard let strongSelf = self,
                    let password = strongSelf.passwordTextField.text else { return }
                
                print("Password = \(password) |||||| Pin = \(value.pin)")
                
                strongSelf.recoveryModel.password = password
                strongSelf.recoveryModel.pin = value.pin
                
                print("Done!")
                
                guard let confirmPhoneViewController = strongSelf.storyboard?.instantiateViewController(withIdentifier: "ConfirmSmsCode")
                    as? ForgottenPasswordConfirmPhoneViewController else {
                        return
                }
                
                confirmPhoneViewController.recoveryModel = strongSelf.recoveryModel
                
                strongSelf.navigationController?.pushViewController(confirmPhoneViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        localize()
        style(textField: passwordTextField)
        style(textField: cofirmPasswordTextField)
    }
    
    private func localize() {
        titleLabel.text = Localize("forgottenPassword.newDesign.changePasswordTitle")
        passwordTextField.placeholder = Localize("forgottenPassword.newDesign.newPasswordPlaceholder")
        cofirmPasswordTextField.placeholder = Localize("forgottenPassword.newDesign.confirmNewPasswordPlaceholder")
        confirmButton.setTitle(Localize("forgottenPassword.newDesign.newPasswordSubmitButton"), for: .normal)
    }
    
    private func style(textField: LimitedHoshiTextField) {
        textField.isSecureTextEntry = true
        textField.returnKeyType = .next
        textField.font = UIFont(name: "Geomanist", size: 16.0)
        textField.placeholderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        textField.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textField.borderActiveColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textField.borderInactiveColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        textField.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @IBAction private func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ChangePasswordViewController: InputForm {

    var textFields: [UITextField] {
        return [
            passwordTextField,
            cofirmPasswordTextField
        ]
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return goToTextField(after: textField)
    }

}
