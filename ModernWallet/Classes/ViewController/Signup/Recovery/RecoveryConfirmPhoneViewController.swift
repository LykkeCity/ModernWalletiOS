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

class RecoveryConfirmPhoneViewController: UIViewController, LWSMSTimerViewDelegate {
    
    func smsTimerViewPressedResend(_ view: LWSMSTimerView!) {
        RecoveryViewModel.instance.resendSmsTrigger.onNext(())
        print("test1")
    }
    
    func smsTimerViewPressedRequestVoiceCall(_ view: LWSMSTimerView!) {
//        RecoveryViewModel.instance.voiceCallTrigger.onNext(())
        print("test2")
        
        
        
    }
    
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var confirmCodeTextField: HoshiTextField!
    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var timerView: LWSMSTimerView!
    
    private let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        timerView.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !timerView.isTimerRunnig() {
            RecoveryViewModel.instance.resendSmsTrigger.onNext(())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerView.delegate = self
        
        scrollView?.subscribeKeyBoard(withDisposeBag: disposeBag)
        scrollView?.keyboardDismissMode = .onDrag
        
        confirmCodeTextField.rx.text.orEmpty
            .bind(to: RecoveryViewModel.instance.smsCode)
            .disposed(by: disposeBag)
        
        RecoveryViewModel.instance.isValidSmsCode
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
//        confirmButton.rx.tap
//            .bind(to: RecoveryViewModel.instance.changePinAndPasswordTrigger)
//            .disposed(by: disposeBag)
        
        RecoveryViewModel.instance.resendSmsData
            .do(onNext: { [weak self] _ in
                self?.timerView.startTimer()
            })
            .map { String(format: Localize("recovery.newDesign.confirmSmsCodeTitle"), $0) }
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
//        RecoveryViewModel.instance.success
//            .subscribe( onNext: { [weak self] in
//                guard let strongSelf = self else { return }
//                
//                RecoveryViewModel.instance.reset()
//                
//                guard let recoveryCompletedViewController = strongSelf.storyboard?.instantiateViewController(withIdentifier: "ShowCompleted")
//                    as? RecoveryCompletedViewController else {
//                        return
//                }
//                
//                strongSelf.navigationController?.pushViewController(recoveryCompletedViewController, animated: true)
//            })
//            .disposed(by: disposeBag)
        
//        RecoveryViewModel.instance.errors
//            .asDriver(onErrorJustReturn: [:])
//            .drive(rx.error)
//            .disposed(by: disposeBag)
//
//        RecoveryViewModel.instance.loadingViewModel.isLoading
//            .bind(to: rx.loading)
//            .disposed(by: disposeBag)
//
//        RecoveryViewModel.instance.voiceCallData
//            .subscribe(onNext: {[weak self] value in
//                guard let strongSelf = self else { return }
//                if value {
//                    strongSelf.showAlert(
//                        title: Localize("recovery.newDesign.requestVoiceCallTitle"),
//                        message: Localize("recovery.newDesign.requestVoiceCallMessage"),
//                        buttonTitle: Localize("recovery.newDesign.requestVoiceCallButtonTitle"))
//                }
//            })
//            .disposed(by: disposeBag)
        
        localize()
        
        style(textField: confirmCodeTextField)
    }
    
    private func localize(){
        titleLabel.text = String(format: Localize("recovery.newDesign.confirmSmsCodeTitle"), "")
        confirmCodeTextField.placeholder = Localize("recovery.newDesign.confirmSmsCodePlaceholder")
//        resendSmsCodeButton.setTitle(Localize("recovery.newDesign.resendCodeTitle"), for: .normal)
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
