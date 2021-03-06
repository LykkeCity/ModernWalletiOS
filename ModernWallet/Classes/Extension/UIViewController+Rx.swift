//
//  UIViewController+Rx.swift
//  ModernWallet
//
//  Created by Georgi Stanev on 24.10.17.
//  Copyright © 2017 Lykkex. All rights reserved.
//

import Foundation
import UIKit
import WalletCore
import RxCocoa
import RxSwift
import Toast
import SwiftSpinner

extension Reactive where Base: UIViewController {
    
    var loading: UIBindingObserver<Base, Bool> {
        return UIBindingObserver(UIElement: self.base) { vc, value in
            
            guard value else {
                vc.hideLoading()
                return
            }
            
            vc.showLoading()
        }
    }
    
    var messageTop: UIBindingObserver<Base, String> {
        return UIBindingObserver(UIElement: self.base) { vc, message in
            vc.view.makeToast(message, duration: 2.0, position: CSToastPositionTop)
        }
    }
    
    var messageBottom: UIBindingObserver<Base, String> {
        return UIBindingObserver(UIElement: self.base) { vc, message in
            vc.view.makeToast(message, duration: 2.0, position: CSToastPositionBottom)
        }
    }
    
    var messageCenter: UIBindingObserver<Base, String> {
        return UIBindingObserver(UIElement: self.base) { vc, message in
            vc.view.makeToast(message, duration: 2.0, position: CSToastPositionCenter)
        }
    }
    
    var error: UIBindingObserver<Base, [AnyHashable: Any]> {
        return UIBindingObserver(UIElement: self.base) { vc, value in
            vc.show(error: value)
        }
    }
}

