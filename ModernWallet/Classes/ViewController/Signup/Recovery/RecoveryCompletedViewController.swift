//
//  RecoveryCompletedViewController.swift
//  ModernMoney
//
//  Created by Vladimir Dimov on 24.07.18.
//  Copyright © 2018 Lykkex. All rights reserved.
//

import UIKit
import WalletCore
import RxSwift

class RecoveryCompletedViewController: UIViewController {
    
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
        titleLabel.text = Localize("recovery.newDesign.completedTitle")
        messageLabel.text = Localize("recovery.newDesign.completedMessage")
        completeButton.setTitle(Localize("recovery.newDesign.completedButtonTitle"), for: .normal)
    }
    
}
