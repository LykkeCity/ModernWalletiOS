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
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var cofirmPasswordTextField: UITextField!
    @IBOutlet private weak var confirmButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView?.subscribeKeyBoard(withDisposeBag: disposeBag)
        scrollView?.keyboardDismissMode = .onDrag
        
        messageLabel.text = Localize("forgottenPassword.newDesign.changePasswordTitle")
        passwordTextField.placeholder = Localize("forgottenPassword.newDesign.newPasswordPlaceholder")
        passwordTextField.placeholder = Localize("forgottenPassword.newDesign.confirmnewPasswordPlaceholder")
        confirmButton.setTitle("forgottenPassword.newDesign.submitButton", for: .normal)
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
