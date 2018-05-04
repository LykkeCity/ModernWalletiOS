//
//  SideNavBar.swift
//  ModernMoneyUITests
//
//  Created by Radi Dichev on 25.04.18.
//  Copyright © 2018 Lykkex. All rights reserved.
//

import Foundation

class SideNavBar: Page {
    let menuIcon = Page.app.buttons["MenuIcon"]
    
    func open() {
        menuIcon.tap()
    }
    
    func selectMenuItem(item: String) {
        Page.app.tables.staticTexts[item].tap()
    }
}


