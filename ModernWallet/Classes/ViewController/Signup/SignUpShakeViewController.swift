//
//  SignUpShakeViewController.swift
//  ModernMoney
//
//  Created by Nacho Nachev on 29.11.17.
//  Copyright © 2017 Lykkex. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import WalletCore

class SignUpShakeViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var instructionsLabel: UILabel!
    @IBOutlet private weak var shakesCountLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    private var shakesCount = 0 {
        didSet {
            self.shakesCountLabel?.text = "\(shakesCount)"
        }
    }
    
    private var seedWords = [Any]()
    
    private let trigger = PublishSubject<Void>()
    
    private lazy var viewModel : ClientKeysViewModel = {
        return ClientKeysViewModel(submit: self.trigger.asObserver())
    }()
    
    private let isLoading = Variable(false)
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SignUpStep.instance = .generateWallet
        
        titleLabel.text = Localize("auth.newDesign.generateKeysTitle")
        instructionsLabel.text = Localize("auth.newDesign.generateKeysInstructions")
        descriptionLabel.text = Localize("auth.newDesign.generateKeysDetails")

        viewModel.loading
            .bind(to: isLoading)
            .disposed(by: disposeBag)

        viewModel.loading
            .bind(to: rx.loading)
            .disposed(by: disposeBag)
        
        let resultObservable = viewModel.result.asObservable()
        
        resultObservable
            .filterError()
            .filter{ !$0.isCodeOne }
            .subscribe(onNext: { [weak self] errorData in
                guard let `self` = self else { return }
                self.show(error: errorData)
                self.shakesCount = 0
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                resultObservable.filterError().filter{ $0.isCodeOne }.map{ _ in Void() },
                resultObservable.filterSuccess().map{ _ in () }
            )
            .delay(0.011, scheduler: MainScheduler.instance) // dirty hack:  delay with more than loading view model delays
            .subscribe { [weak self] _ in
                SignUpStep.resetInstance()
                UserDefaults.standard.isLoggedIn = true
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: .loggedIn, object: nil)
                
                self?.navigationController?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }

    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        guard motion == .motionShake, shakesCount < 3 else {
            return
        }
        shakesCount += 1
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        guard motion == .motionShake, shakesCount == 3 else {
            generateKeys()
            return
        }
        guard !isLoading.value else {
            return
        }
        generateKeys()
        sendKeys()
    }
    
    private func generateKeys() {
        seedWords = LWPrivateKeyManager.generateSeedWords12()
    }
    
    private func sendKeys() {
        LWPrivateKeyManager.shared().savePrivateKeyLykke(fromSeedWords: seedWords)
        viewModel.pubKey.value = LWPrivateKeyManager.shared().publicKeyLykke
        viewModel.encodedPrivateKey.value = LWPrivateKeyManager.shared().encryptedKeyLykke
        trigger.onNext(())
    }
    
}

extension Dictionary where Key == AnyHashable{
    
    
    /// If the error code is one this could be interpreted that the entity is already created
    var isCodeOne: Bool {
        guard let code = self["Code"] as? Int else {
            return false
        }
        
        return code == 1
    }
}
