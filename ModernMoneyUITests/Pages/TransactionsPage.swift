//
//  TransactionsPage.swift
//  ModernMoneyUITests
//
//  Created by Radi Dichev on 9.05.18.
//  Copyright © 2018 Lykkex. All rights reserved.
//

class TransactionsPage: Page {
    
    func open() {
        SideNavBar().open()
        Page.app.tables.cells.staticTexts["TRANSACTIONS"].tap()
    }
}
