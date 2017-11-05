//
//  CashOutSummaryViewController.swift
//  ModernWallet
//
//  Created by Nacho Nachev on 5.11.17.
//  Copyright © 2017 Lykkex. All rights reserved.
//

import UIKit
import WalletCore

class CashOutSummaryViewController: UIViewController {
    
    @IBOutlet private weak var backgroundHeightConstraint: NSLayoutConstraint!

    @IBOutlet private weak var successLabel: UILabel!
    @IBOutlet private weak var detailsLabel: UILabel!
    @IBOutlet private weak var waitMessageLabel: UILabel!
    @IBOutlet private weak var amountView: AssetAmountView!
    @IBOutlet private weak var bankNameTitleLabel: UILabel!
    @IBOutlet private weak var bankNameLabel: UILabel!
    @IBOutlet private weak var ibanTitleLabel: UILabel!
    @IBOutlet private weak var ibanLabel: UILabel!
    @IBOutlet private weak var bicTitleLabel: UILabel!
    @IBOutlet private weak var bicLabel: UILabel!
    @IBOutlet private weak var accountHolderTitleLabel: UILabel!
    @IBOutlet private weak var accountHolderLabel: UILabel!
    @IBOutlet private weak var button: UIButton!
    
    var result: LWModelCashOutSwiftResult!

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundHeightConstraint.constant = Display.height
        
        successLabel.text = Localize("cashOut.newDesign.success")
        detailsLabel.text = Localize("cashOut.newDesign.success")
        waitMessageLabel.text = Localize("cashOut.newDesign.success")
        bankNameTitleLabel.text = Localize("cashOut.newDesign.success")
        ibanTitleLabel.text = Localize("cashOut.newDesign.success")
        bicTitleLabel.text = Localize("cashOut.newDesign.success")
        accountHolderTitleLabel.text = Localize("cashOut.newDesign.success")
        button.setTitle(Localize("cashOut.newDesign.backToPortfolio"), for: .normal)
        
        amountView.amount = result.amount
        amountView.code = result.asset
        bankNameLabel.text = result.bankName
        ibanLabel.text = result.iban
        bicLabel.text = result.bic
        accountHolderLabel.text = result.accountHolder
    }

}
