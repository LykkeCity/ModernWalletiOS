//
//  ForgottenPasswordCheckWordsViewController.swift
//  ModernMoney
//
//  Created by Vladimir Dimov on 24.07.18.
//  Copyright © 2018 Lykkex. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import WalletCore

class ForgottenPasswordCheckWordsViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var typingTextField: LimitedHoshiTextField!
    @IBOutlet private weak var confirmButton: UIButton!
    
    var email: String!
    
    static var createForgottenPasswordCheckWordsViewController: Observable<UINavigationController> {
        guard let viewController = UIStoryboard(name: "ForgottenPassword", bundle: nil).instantiateViewController(withIdentifier: "CheckWords") as? UINavigationController else { return Observable.empty() }
        // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
        viewController.modalPresentationStyle = .custom
        return Observable.just(viewController)
    }
    
    lazy var validateSeedWordsViewModel: ValidateSeedWordsViewModel = {
        return ValidateSeedWordsViewModel(email: self.email)
    }()
 
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(closeRecovery))
        
        typingTextField.delegate = self
        
        scrollView?.subscribeKeyBoard(withDisposeBag: disposeBag)
        scrollView?.keyboardDismissMode = .onDrag
        
        typingTextField.rx.text
            .orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: validateSeedWordsViewModel.typedText)
            .disposed(by: disposeBag)
        
        validateSeedWordsViewModel.areSeedWordsCorrect
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)

        confirmButton.rx.tap
            .debug("confirmbutton")
            .bind(to: validateSeedWordsViewModel.checkTrigger)
            .disposed(by: disposeBag)
        
        validateSeedWordsViewModel.isOwnershipConfirmed
            .subscribe(onNext: { [weak self] isConfirmed in
                guard let strongSelf = self else { return }
                
                print("We got our response from the server. And it is: \(isConfirmed)")
                
//                guard isConfirmed else {
//                    let alert = UIAlertController(title: Localize("restore.form.wrongseed.title"),
//                                                  message: Localize("restore.form.wrongseed.text"),
//                                                  preferredStyle: .alert)
//
//                    alert.addAction(UIAlertAction(title: Localize("restore.form.wrongseed.ok"), style: .cancel, handler: nil))
//
//                    strongSelf.navigationController?.present(alert, animated: true, completion: nil)
//
//                    return
//                }
                let recoveryModel = LWRecoveryPasswordModel()
                recoveryModel.email = strongSelf.email
                
                guard let changePasswordViewController = self?.storyboard?.instantiateViewController(withIdentifier: "ChangePassword")
                    as? ChangePasswordViewController else {
                        return
                }
                    changePasswordViewController.recoveryModel = recoveryModel
                    
                    self?.navigationController?.pushViewController(changePasswordViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        validateSeedWordsViewModel.loadingViewModel.isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(rx.loading)
            .disposed(by: disposeBag)

//        viewModel.loadingViewModel.isLoading
//            .asDriver(onErrorJustReturn: false)
//            .drive(rx.loading)
//            .disposed(by: disposeBag)
//
//        viewModel.errors
//            .asDriver(onErrorJustReturn: [:])
//            .drive(rx.error)
//            .disposed(by: disposeBag)
//
//        viewModel.success
//            .asDriver(onErrorJustReturn: ())
//            .drive(onNext: { [weak self] _ in
//                self?.performSegue(withIdentifier: "ShowComplete", sender: nil)
//            })
//            .disposed(by: disposeBag)
        localize()
        style(textField: typingTextField)
    }
    
    private func localize(){
        messageLabel.text = Localize("forgottenPassword.newDesign.checkWordsTitle")
        typingTextField.placeholder = Localize("forgottenPassword.newDesign.checkWordsTextFieldPlaceholder")
        confirmButton.setTitle(Localize("forgottenPassword.newDesign.checkWordsSubmitButton"), for: .normal)
    }
    
    private func style(textField: LimitedHoshiTextField) {
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @objc func closeRecovery() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension ForgottenPasswordCheckWordsViewController: UITextFieldDelegate {
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let text = textField.text else {
//            return true
//        }
//        let newText = (text as NSString).replacingCharacters(in: range, with: string)
//        let wordsCount = newText.components(separatedBy: " ").count
//        return newText.range(of: "  ") == nil && wordsCount <= words.count
//    }
}

extension UITextField {
    
    fileprivate func setAttributedTextAndPreserveState(_ attributedText: NSAttributedString) {
        let selectedTextRange = self.selectedTextRange
        guard let bounds = self.textInputView.superview?.bounds else { return }
        self.attributedText = attributedText
        self.textInputView.superview?.bounds = bounds
        self.selectedTextRange = selectedTextRange
    }
    
}
