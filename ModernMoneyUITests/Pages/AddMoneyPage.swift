//
//  AddMoneyPage.swift
//  ModernMoneyUITests
//
//  Created by Radi Dichev on 3.05.18.
//  Copyright © 2018 Lykkex. All rights reserved.
//

import Foundation

class AddMoneyPage: Page {
    let backBtn = Page.app/*@START_MENU_TOKEN@*/.buttons["backArrow"]/*[[".buttons[\"backArrow\"]",".buttons[\"Back button\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
    
    func open() {
        SideNavBar().open()
        Page.app.tables.cells.staticTexts["ADD MONEY"].tap()
    }
    
    func selectBankAccountOption() {
        //TODO:
    }
    
    func selectCreditCardOption() {
        // refactor
        Page.app.otherElements["Start view"].children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 3).children(matching: .button).element.tap()
    }
    
    func selectReceiveCryptoCurrencyOption() {
        //TODO:
    }
    
    func selectCurrency(currency: String) {
        Page.app.cells.staticTexts[currency].tap()
    }
    
    func tapBackBtn() {
        backBtn.tap()
    }
}
