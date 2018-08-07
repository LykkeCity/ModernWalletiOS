//
//  ForgottenPasswordCompletedViewController.swift
//  ModernMoney
//
//  Created by Vladimir Dimov on 24.07.18.
//  Copyright © 2018 Lykkex. All rights reserved.
//

import UIKit
import WalletCore
import RxSwift

class ForgottenPasswordCompletedViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var completeButton: UIButton!
    
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localize()
        
        completeButton.rx.tap.bind{ [weak self] in
            self?.presentLoginController()
            }.disposed(by: disposeBag)
    }
    
    func localize(){
        titleLabel.text = Localize("forgottenPassword.newDesign.completedTitle")
        messageLabel.text = Localize("forgottenPassword.newDesign.completedMessage")
        completeButton.setTitle(Localize("forgottenPassword.newDesign.completedButtonTitle"), for: .normal)
    }
    
}
