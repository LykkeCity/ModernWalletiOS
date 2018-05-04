//
//  SettingsPage.swift
//  ModernMoneyUITests
//
//  Created by Radi Dichev on 27.04.18.
//  Copyright © 2018 Lykkex. All rights reserved.
//

class SettingsPage: Page {
    let baseAssetItem = Page.app.staticTexts["BASE ASSET"]
    let backNavArrow = Page.app.buttons["backArrow"]
    
    func open() {
        SideNavBar().open()
        SideNavBar().selectMenuItem(item: "SETTINGS")
    }
    
//    func getSelectedBaseAsset() -> String {
//        return Page.app.staticText
//    }
    
    func selectBaseAsset(baseAsset: String) {
        baseAssetItem.tap()
        Page.app.staticTexts[baseAsset].tap()
    }
    
    func goBack() {
        backNavArrow.tap()
    }
}
