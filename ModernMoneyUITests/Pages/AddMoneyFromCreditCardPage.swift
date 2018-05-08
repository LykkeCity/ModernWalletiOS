//
//  AddMoneyFromCreditCardPage.swift
//  ModernMoneyUITests
//
//  Created by Radi Dichev on 4.05.18.
//  Copyright © 2018 Lykkex. All rights reserved.
//

import Foundation


class AddMoneyFromCreditCardPage: Page {
    
//    let amountFieldTextField = Page.app/*@START_MENU_TOKEN@*/.scrollViews["Scroll view"]/*[[".otherElements[\"Start view\"].scrollViews[\"Scroll view\"]",".scrollViews[\"Scroll view\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements.elementsQuery./*@START_MENU_TOKEN@*/.textFields["Amount field"]/*[[".textFields[\"00.00\"]",".textFields[\"Amount field\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    let amountFieldTextField = Page.app.textFields["Amount field"]
    let addMoneyLabel = Page.app.staticTexts["Add Mopney Label"]
    let assetSymbol = Page.app/*@START_MENU_TOKEN@*/.scrollViews["Scroll view"]/*[[".otherElements[\"Start view\"].scrollViews[\"Scroll view\"]",".scrollViews[\"Scroll view\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements/*@START_MENU_TOKEN@*/.staticTexts["Asset Symbol"]/*[[".staticTexts[\"€\"]",".staticTexts[\"Asset Symbol\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    let assetCode = Page.app/*@START_MENU_TOKEN@*/.scrollViews["Scroll view"]/*[[".otherElements[\"Start view\"].scrollViews[\"Scroll view\"]",".scrollViews[\"Scroll view\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements.staticTexts["Asset Code"]
    let ccConteinerViewElement = Page.app/*@START_MENU_TOKEN@*/.otherElements["cc conteiner view"]/*[[".otherElements[\"Start view\"]",".scrollViews[\"Scroll view\"].otherElements[\"cc conteiner view\"]",".otherElements[\"cc conteiner view\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
    let firstNameField = Page.app/*@START_MENU_TOKEN@*/.otherElements["cc conteiner view"]/*[[".otherElements[\"Start view\"]",".scrollViews[\"Scroll view\"].otherElements[\"cc conteiner view\"]",".otherElements[\"cc conteiner view\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*//*@START_MENU_TOKEN@*/.textFields["First name field"]/*[[".textFields[\"FIRST NAME\"]",".textFields[\"First name field\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    let lastNameField =  Page.app/*@START_MENU_TOKEN@*/.otherElements["cc conteiner view"]/*[[".otherElements[\"Start view\"]",".scrollViews[\"Scroll view\"].otherElements[\"cc conteiner view\"]",".otherElements[\"cc conteiner view\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*//*@START_MENU_TOKEN@*/.textFields["Last name field"]/*[[".textFields[\"LAST NAME\"]",".textFields[\"Last name field\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    let addressField = Page.app/*@START_MENU_TOKEN@*/.textFields["Address field"]/*[[".textFields[\"ADDRESS\"]",".textFields[\"Address field\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    let cityField = Page.app/*@START_MENU_TOKEN@*/.textFields["City field"]/*[[".textFields[\"CITY\"]",".textFields[\"City field\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    let zipField = Page.app/*@START_MENU_TOKEN@*/.textFields["Zip field"]/*[[".textFields[\"ZIP\"]",".textFields[\"Zip field\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    let countryField = Page.app/*@START_MENU_TOKEN@*/.textFields["Country field"]/*[[".textFields[\"COUNTRY\"]",".textFields[\"Country field\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    // Page.app/*@START_MENU_TOKEN@*/.staticTexts["Albania"]/*[[".cells.staticTexts[\"Albania\"]",".staticTexts[\"Albania\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    let codeField = Page.app/*@START_MENU_TOKEN@*/.textFields["Code field"]/*[[".textFields[\"Code\"]",".textFields[\"Code field\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    let phoneField = Page.app/*@START_MENU_TOKEN@*/.textFields["Phone field"]/*[[".textFields[\"Phone\"]",".textFields[\"Phone field\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    let doneBtn = Page.app.buttons["DONE"]
    let submitBtn = Page.app/*@START_MENU_TOKEN@*/.buttons["Submit button"]/*[[".otherElements[\"Start view\"]",".buttons[\"SUBMIT\"]",".buttons[\"Submit button\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
    let emptyAmountErrMessage = Page.app/*@START_MENU_TOKEN@*/.staticTexts["Field Amount should not be empty"]/*[[".otherElements[\"Start view\"].staticTexts[\"Field Amount should not be empty\"]",".staticTexts[\"Field Amount should not be empty\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    let searchField = Page.app.searchFields["Search"]
    
    func clearField() {
    // TODO:
    }
    
    func enterAmount(amount: String) {
        amountFieldTextField.tap()
        amountFieldTextField.typeText(amount)
    }
    
    func getAmount() -> String {
       return amountFieldTextField.value as! String
    }
    
    func getAssetSymbol() -> String {
        return assetSymbol.value as! String
    }
    
    func getAssetCode() -> String {
        return assetCode.value as! String
    }
    
    func enterFirstName(firstName: String) {
        firstNameField.tap()
        let fieldValue = firstNameField.value as! String
        if fieldValue != "" {
            var strLen = fieldValue.count
            while strLen != 0 {
                Page.app/*@START_MENU_TOKEN@*/.keyboards.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
                strLen = strLen - 1
            }
        }
        firstNameField.typeText(firstName)
    }
    
    func enterLastName(lastName: String) {
        lastNameField.tap()
        let fieldValue = lastNameField.value as! String
        if fieldValue != "" {
            var strLen = fieldValue.count
            while strLen != 0 {
                Page.app/*@START_MENU_TOKEN@*/.keyboards.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
                strLen = strLen - 1
            }
        }
        lastNameField.typeText(lastName)
    }
    
    func enterAddress(address: String) {
        addressField.tap()
        let fieldValue = addressField.value as! String
        if fieldValue != "" {
            var strLen = fieldValue.count
            while strLen != 0 {
                Page.app/*@START_MENU_TOKEN@*/.keyboards.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
                strLen = strLen - 1
            }
        }
        addressField.typeText(address)
    }
    
    func enterCity(city: String) {
        cityField.tap()
        let fieldValue = cityField.value as! String
        if fieldValue != "" {
            var strLen = fieldValue.count
            while strLen != 0 {
                Page.app/*@START_MENU_TOKEN@*/.keyboards.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
                strLen = strLen - 1
            }
        }
        cityField.typeText(city)
    }
    
    func enterCounty(country: String) {
        //Todo:
        countryField.tap()
        searchField.tap()
        searchField.typeText(country)
        Page.app.tables.staticTexts[country].tap()
    }
    
    func enterZip(zip: String) {
        zipField.tap()
        let fieldValue = zipField.value as! String
        if fieldValue != "" {
            var strLen = fieldValue.count
            while strLen != 0 {
                Page.app.keys["Delete"].tap()
                strLen = strLen - 1
            }
        }
        zipField.typeText(zip)
    }
    
    func enterPhoneCode(code: String) {
        codeField.tap()
        let fieldValue = codeField.value as! String
        if fieldValue != "" {
            var strLen = fieldValue.count
            while strLen != 0 {
                Page.app.keys["Delete"].tap()
                strLen = strLen - 1
            }
        }
        codeField.typeText(code)
    }
    
    func enterPhone(phone: String) {
        phoneField.tap()
        let fieldValue = phoneField.value as! String
        if fieldValue != "" {
            var strLen = fieldValue.count
            while strLen != 0 {
                Page.app.keys["Delete"].tap()
                strLen = strLen - 1
            }
        }
        phoneField.typeText(phone)
    }
    
    func tapDone() {
        doneBtn.tap()
    }
    
    func tapSubmit() {
        submitBtn.tap()
    }
}
