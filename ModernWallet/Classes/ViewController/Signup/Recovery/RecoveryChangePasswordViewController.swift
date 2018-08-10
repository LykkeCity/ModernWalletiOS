//
//  RecoveryChangePasswordViewController.swift
//  ModernMoney
//
//  Created by Vladimir Dimov on 24.07.18.
//  Copyright © 2018 Lykkex. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import WalletCore
import TextFieldEffects

class RecoveryChangePasswordViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var cofirmPasswordTextField: HoshiTextField!
    @IBOutlet weak var hintTextField: HoshiTextField!
    @IBOutlet private weak var confirmButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    /// Change password viewModel
    lazy var changePasswordViewModel : ChangePasswordViewModel = {
        return ChangePasswordViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView?.subscribeKeyBoard(withDisposeBag: disposeBag)
        scrollView?.keyboardDismissMode = .onDrag
        
        let passwordValue = passwordTextField.rx.text.orEmpty
            .shareReplay(1)
        
        passwordValue
            .bind(to: changePasswordViewModel.password)
            .disposed(by: disposeBag)
        
        passwordValue
            .bind(to: RecoveryViewModel.instance.newPassword)
            .disposed(by: disposeBag)
        
        let hintValue = hintTextField.rx.text.orEmpty
            .shareReplay(1)
        
        hintValue
            .bind(to: changePasswordViewModel.hint)
            .disposed(by: disposeBag)
        
        hintValue
            .bind(to: RecoveryViewModel.instance.newHint)
            .disposed(by: disposeBag)
        
//        passwordTextField.rx.returnTap
//            .subscribe(onNext: { [weak self] isConfirmed in
//                guard let strongSelf = self else { return }
//                strongSelf.cofirmPasswordTextField.becomeFirstResponder()
//            })
//            .disposed(by: disposeBag)
        
        cofirmPasswordTextField.rx.text.orEmpty
            .bind(to: changePasswordViewModel.confirmPassword)
            .disposed(by: disposeBag)
        
//        cofirmPasswordTextField.rx.returnTap
//            .withLatestFrom(viewModel.isValid.asObservable())
//            .filterTrueAndBind(toTrigger: nextTrigger)
//            .disposed(by: disposeBag)
        
        changePasswordViewModel.isValid
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        let pinAndPasswordValue = confirmButton.rx.tap
            .flatMapLatest { [weak self]  _ -> Observable<(complete: Bool, pin: String)> in
                guard let strongSelf = self else { return .never() }
                return PinViewController.presentResetPinController(from: strongSelf, title: "Hello world")
            }
            .filter { $0.complete }
            .shareReplay(1)
        
        pinAndPasswordValue
            .map { $0.pin }
            .bind(to: RecoveryViewModel.instance.newPin)
            .disposed(by: disposeBag)
            
        pinAndPasswordValue
            .subscribe(onNext: { [weak self] value in
                guard let strongSelf = self,
                    let password = strongSelf.passwordTextField.text else { return }
                
                print("Password = \(password) |||||| Pin = \(value.pin)")
                
                print("Done!")
                
                guard let recoveryConfirmPhoneViewController = strongSelf.storyboard?.instantiateViewController(withIdentifier: "ConfirmSmsCode")
                    as? RecoveryConfirmPhoneViewController else {
                        return
                }

                strongSelf.navigationController?.pushViewController(recoveryConfirmPhoneViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        localize()
        style(textField: passwordTextField, secureText: true)
        style(textField: cofirmPasswordTextField, secureText: true)
        style(textField: hintTextField)
    }
    
    private func localize() {
        titleLabel.text = Localize("recovery.newDesign.changePasswordTitle")
        passwordTextField.placeholder = Localize("recovery.newDesign.newPasswordPlaceholder")
        cofirmPasswordTextField.placeholder = Localize("recovery.newDesign.confirmNewPasswordPlaceholder")
        hintTextField.placeholder = Localize("recovery.newDesign.hintPlaceholder")
        confirmButton.setTitle(Localize("recovery.newDesign.newPasswordSubmitButton"), for: .normal)
    }
    
    private func style(textField: HoshiTextField) {
        style(textField: textField, secureText: false)
    }
    
    private func style(textField: HoshiTextField, secureText: Bool) {
        textField.isSecureTextEntry = secureText
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

extension RecoveryChangePasswordViewController: InputForm {

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
