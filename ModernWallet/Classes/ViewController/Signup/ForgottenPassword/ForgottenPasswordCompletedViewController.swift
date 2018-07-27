//
//  ForgottenPasswordCompletedViewController.swift
//  ModernMoney
//
//  Created by Vladimir Dimov on 24.07.18.
//  Copyright © 2018 Lykkex. All rights reserved.
//

import UIKit
import WalletCore

class ForgottenPasswordCompletedViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var completeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = Localize("forgottenPassword.newDesign.completeTitle")
        messageLabel.text = Localize("forgottenPassword.newDesign.completeMessage")
        completeButton.setTitle(Localize("forgottenPassword.newDesign.buttonTitle"), for: .normal)
    }
    
}
