//
//  SettingsTableViewCell.swift
//  ModernWallet
//
//  Created by Nacho Nachev on 14.11.17.
//  Copyright © 2017 Lykkex. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var separator: SeparatorView!
    
    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let backroundView = UIView()
        backroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1967840325)
        selectedBackgroundView = backroundView
    }
    
}