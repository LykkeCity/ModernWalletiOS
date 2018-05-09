                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             //
//  BuyPage.swift
//  ModernMoneyUITests
//
//  Created by Radi Dichev on 8.05.18.
//  Copyright © 2018 Lykkex. All rights reserved.
//

class BuyPage: Page {
    
    let firstAssetListElement = Page.app.scrollViews["Scroll view"].otherElements.otherElements["First asset list"]
    let secondAssetListElement = Page.app.scrollViews["Scroll view"].otherElements.otherElements["Second asset list"]
    
    let buyButton = Page.app.buttons["BUY"]
    let doneButton = Page.app.buttons["DONE"]
    let nextButton = Page.app.buttons["NEXT"]
    
    func open() {
        SideNavBar().open()
        Page.app.tables.cells.staticTexts["BUY"].tap()
    }
    
    func getSelectedBuyAsset() -> String {
        return firstAssetListElement.staticTexts["Asset name"].label
    }
    
    func getSelectedPayWithAsset() -> String {
        return secondAssetListElement.staticTexts["Asset name"].label
    }
    
    func selectBuyAsset(asset: String) {
        let selectedAsset =  getSelectedBuyAsset()
    firstAssetListElement.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 0).tap() //TODO
    
        Page.app.pickerWheels[selectedAsset].adjust(toPickerWheelValue: asset)
        Page.app.pickerWheels[asset].tap()
    }
    
    func selectPayWithAsset(asset: String) {
        let selectedAsset =  getSelectedPayWithAsset()
    secondAssetListElement.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 0).tap() //TODO
        
        Page.app.pickerWheels[selectedAsset].adjust(toPickerWheelValue: asset)
        Page.app.pickerWheels[asset].tap()
    }
    
    func enterBuyAmount(amount: String) {
        firstAssetListElement.textFields["00.00"].tap()
        firstAssetListElement.typeText(amount)
    }
    
    func enterPayWithAmount(amount: String) {
        secondAssetListElement.textFields["00.00"].tap()
        secondAssetListElement.typeText(amount)
    }
    
    func tapBuyBtn() {
        buyButton.tap()
    }
    
    func tapNextBtn() {
        nextButton.tap()
    }
    
    func tapDoneBtn() {
        doneButton.tap()
    }
}
