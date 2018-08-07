//
//  ForgottenPasswordConfirmPhoneViewController.swift
//  ModernMoney
//
//  Created by Vladimir Dimov on 24.07.18.
//  Copyright © 2018 Lykkex. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import WalletCore

class ForgottenPasswordConfirmPhoneViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var cofirmCodeTextField: LimitedHoshiTextField!
    @IBOutlet private weak var haventReceiveCodeButton: UIButton!
    @IBOutlet private weak var confirmButton: UIButton!
    
    public var recoveryModel = LWRecoveryPasswordModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView?.subscribeKeyBoard(withDisposeBag: disposeBag)
        scrollView?.keyboardDismissMode = .onDrag
        
        localize()
        
        style(textField: cofirmCodeTextField)
    }
    
    private func localize(){
        setTitleLabel(text: Localize("forgottenPassword.newDesign.confirmSmsCodeTitle"), number: "007")
        cofirmCodeTextField.placeholder = Localize("forgottenPassword.newDesign.confirmSmsCodePlaceholder")
        haventReceiveCodeButton.setTitle(Localize("forgottenPassword.newDesign.resendCodeTitle"), for: .normal)
        confirmButton.setTitle(Localize("forgottenPassword.newDesign.confirmSmsCodeButtonTitle"), for: .normal)
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
    
    private func setTitleLabel(text :String, number: String){
        titleLabel.text = String(format: text, number)
    }
    
    @IBAction private func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

//extension ChangePasswordViewController: InputForm {
//
//    var textFields: [UITextField] {
//        return [
//            cofirmCodeTextField
//        ]
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return goToTextField(after: textField)
//    }
//
//}
