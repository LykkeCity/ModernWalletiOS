//
//  SellPage.swift
//  ModernMoneyUITests
//
//  Created by Radi Dichev on 10.05.18.
//  Copyright © 2018 Lykkex. All rights reserved.
//

import Foundation

class SellPage: Page {
    
    let firstAssetListElement = Page.app.scrollViews["Scroll view"].otherElements.otherElements["First asset list"]
    let secondAssetListElement = Page.app.scrollViews["Scroll view"].otherElements.otherElements["Second asset list"]
    
    let sellButton = Page.app.buttons["SELL"]
    let doneButton = Page.app.buttons["DONE"]
    let nextButton = Page.app.buttons["NEXT"]
    
    func open() {
        SideNavBar().open()
        Page.app.tables.cells.staticTexts["SELL"].tap()
    }
    
    func getSelectedSellAsset() -> String {
        return firstAssetListElement.staticTexts["Asset name"].label
    }
    
    func getSelectedReceiveAsset() -> String {
        return secondAssetListElement.staticTexts["Asset name"].label
    }
    
    func selectSellAsset(asset: String) {
        let selectedAsset =  getSelectedSellAsset()
        firstAssetListElement.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 0).tap() //TODO
        
        Page.app.pickerWheels[selectedAsset].adjust(toPickerWheelValue: asset)
        Page.app.pickerWheels[asset].tap()
    }
    
    func selectReceiveAsset(asset: String) {
        let selectedAsset =  getSelectedReceiveAsset()
        secondAssetListElement.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 0).tap() //TODO
        
        Page.app.pickerWheels[selectedAsset].adjust(toPickerWheelValue: asset)
        Page.app.pickerWheels[asset].tap()
    }
    
    func enterSellAmount(amount: String) {
        firstAssetListElement.textFields["00.00"].tap()
        firstAssetListElement.typeText(amount)
    }
    
    func enterReceiveAmount(amount: String) {
        secondAssetListElement.textFields["00.00"].tap()
        secondAssetListElement.typeText(amount)
    }
    
    func tapSellBtn() {
        sellButton.tap()
    }
    
    func tapNextBtn() {
        nextButton.tap()
    }
    
    func tapDoneBtn() {
        doneButton.tap()
    }
}
