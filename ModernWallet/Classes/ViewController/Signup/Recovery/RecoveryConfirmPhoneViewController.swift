//
//  RecoveryConfirmPhoneViewController.swift
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

class RecoveryConfirmPhoneViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var confirmCodeTextField: HoshiTextField!
    @IBOutlet private weak var resendSmsCodeButton: UIButton!
    @IBOutlet private weak var confirmButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView?.subscribeKeyBoard(withDisposeBag: disposeBag)
        scrollView?.keyboardDismissMode = .onDrag
        
        confirmCodeTextField.rx.text.orEmpty
            .bind(to: RecoveryViewModel.instance.smsCode)
            .disposed(by: disposeBag)
        
        RecoveryViewModel.instance.isValidSmsCode
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        resendSmsCodeButton.rx.tap
            .bind(to: RecoveryViewModel.instance.resendSmsTrigger)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .bind(to: RecoveryViewModel.instance.changePinAndPasswordTrigger)
            .disposed(by: disposeBag)
        
        RecoveryViewModel.instance.resendSmsData
            .subscribe( onNext: { [weak self] phone, signedOwnershipMsg in
                guard let strongSelf = self else { return }
                strongSelf.setTitleLabel(text: Localize("recovery.newDesign.confirmSmsCodeTitle"), number: phone)
            })
            .disposed(by: disposeBag)
        
        RecoveryViewModel.instance.success
            .subscribe( onNext: { [weak self] in
                guard let strongSelf = self else { return }
                
                RecoveryViewModel.instance.reset()
                
                guard let recoveryCompletedViewController = strongSelf.storyboard?.instantiateViewController(withIdentifier: "ShowCompleted")
                    as? RecoveryCompletedViewController else {
                        return
                }
                
                strongSelf.navigationController?.pushViewController(recoveryCompletedViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        //Push the trigger when you enter the view controller for the first time
        RecoveryViewModel.instance.resendSmsTrigger.onNext(())
        
        RecoveryViewModel.instance.loadingViewModel.isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(rx.loading)
            .disposed(by: disposeBag)
        
        localize()
        
        style(textField: confirmCodeTextField)
    }
    
    private func localize(){
        setTitleLabel(text: Localize("recovery.newDesign.confirmSmsCodeTitle"), number: "007")
        confirmCodeTextField.placeholder = Localize("recovery.newDesign.confirmSmsCodePlaceholder")
        resendSmsCodeButton.setTitle(Localize("recovery.newDesign.resendCodeTitle"), for: .normal)
        confirmButton.setTitle(Localize("recovery.newDesign.confirmSmsCodeButtonTitle"), for: .normal)
    }
    
    private func style(textField: HoshiTextField) {
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
