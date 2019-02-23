
//
//  UIBarButtonItem.swift
//  ModernWallet
//
//  Created by Georgi Stanev on 9/28/17.
//  Copyright © 2017 Lykkex. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: UIBarButtonItem {
    
    var title: UIBindingObserver<Base, String> {
        return UIBindingObserver(UIElement: self.base) { button, value in
            button.title = value
        }
    }
}
