//
//  BuyAssetListView.swift
//  ModernWallet
//
//  Created by Georgi Stanev on 10/9/17.
//  Copyright © 2017 Lykkex. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import WalletCore

@IBDesignable
class BuyAssetListView: UIView {

    @IBOutlet weak var tapToSelectAsset: UITapGestureRecognizer!
    @IBOutlet weak var baseAssetCode: UILabel!
    @IBOutlet weak var amontInBase: UILabel!
    @IBOutlet weak var assetCode: UILabel!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var assetName: UILabel!
    @IBOutlet weak var assetIcon: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet var view: UIView!
    
    let itemPicker = (picker: UIPickerView(), field: UITextField())
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)!
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib("BuyAssetListView")
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func setupUX(width: CGFloat, disposedBy disposeBag: DisposeBag) {
        itemPicker.field.inputView = itemPicker.picker
        view.addSubview(itemPicker.field)
        
        setupFormUX(forWidth: width, disposedBy: disposeBag)
        
        tapToSelectAsset.rx.event.asObservable()
            .subscribe(onNext: {[weak self] _ in
                self?.itemPicker.field.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 315.0, height: 104.0)
    }

}

extension BuyAssetListView: InputForm {

    var textFields: [UITextField] { return [itemPicker.field] }

    func submitForm() {}
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return goToTextField(after: textField)
    }

}

// MARK: - UI testing purposes
extension BuyAssetListView {
    fileprivate func settupAccessiabilityIdentifiers() {
        // tapToSelectAsset.accessibilityIdentifier = "Tap to select asset"
        baseAssetCode.accessibilityIdentifier = "Base asset code"
        amontInBase.accessibilityIdentifier = "Amount in base asset"
        assetCode.accessibilityIdentifier = "Asset Code"
        amount.accessibilityIdentifier = "Amount"
        assetName.accessibilityIdentifier = "Asset name"
        assetIcon.accessibilityIdentifier = "Asset icon"
        label.accessibilityIdentifier = "Label"
        }
    }

