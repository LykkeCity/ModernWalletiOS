//
//  RecoverySeedWordsFormController.swift
//  ModernMoney
//
//  Created by Lyubomir Marinov on 12.08.18.
//  Copyright © 2018 Lykkex. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import WalletCore

class RecoverySeedWordsFormController: RecoveryController {
    
    init(email: String) {
        self.seedWordsViewModel.email.value = email
        recoveryModel.email = email
    }
    
    lazy var recoveryModel: LWRecoveryPasswordModel = {
        return LWRecoveryPasswordModel()
    }()
    
    lazy var seedWordsViewModel: ValidateWordsViewModel = {
       return ValidateWordsViewModel()
    }()
    
    lazy var formViews: [UIView] = {
        return [
            self.titleLabel(title: Localize("restore.form.text")),
            self.seedWordsTextField
        ]
    }()
    
    var canGoBack: Bool {
        return true
    }
    
    var buttonTitle: String? {
        return Localize("restore.form.next")
    }
    
    var next: FormController? {
        return nil
    }
    
    var segueIdentifier: String? {
        return nil
    }

    var recoveryStep: RecoveryController? {
        return RecoverySetPasswordFormController(recoveryModel: self.recoveryModel)
    }
    
    var setPinObservable: PublishSubject<(complete: Bool, pin: String)>? {
        return nil
    }
    
    lazy private(set) var seedWordsTextField: UITextField = {
        let textField = self.textField(placeholder: Localize("restore.form.placeholder"))
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .next
        return textField
    }()
    
    private let isLoading = Variable<Bool>(false)
    
    private var checkWordsTrigger = PublishSubject<Void>()
    
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
        
        seedWordsTextField.rx.text
            .orEmpty
            .bind(to: seedWordsViewModel.seedWords)
            .disposed(by: disposeBag)
        
        seedWordsViewModel.areSeedWordsValid
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag)
        
        checkWordsTrigger
            .bindToResignFirstResponder(views: formViews)
            .disposed(by: disposeBag)
        
        button.rx.tap
            .bind(to: checkWordsTrigger)
            .disposed(by: disposeBag)
        
        checkWordsTrigger
            .bind(to: seedWordsViewModel.trigger)
            .disposed(by: disposeBag)
        
        seedWordsViewModel.isOwnershipConfirmed
            .filter { $0 }
            .map { _ in return () }
            .waitFor(isLoading.asObservable())
            .bind(to: recoveryTrigger)
            .disposed(by: disposeBag)

        seedWordsViewModel.loadingViewModel.isLoading
            .bind(to: self.isLoading)
            .disposed(by: disposeBag)
        
        isLoading.asObservable()
            .bind(to: loading)
            .disposed(by: disposeBag)
        
        seedWordsViewModel.loadingViewModel
            .isLoading
            .bind(to: loading)
            .disposed(by: disposeBag)
    }

    func unbind() {
        self.isLoading.value = false
        disposeBag = DisposeBag()
    }

}
