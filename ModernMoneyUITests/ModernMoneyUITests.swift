//
//  ModernMoneyUITests.swift
//  ModernMoneyUITests
//
//  Created by Radi Dichev on 29.03.18.
//  Copyright © 2018 Lykkex. All rights reserved.
//

import XCTest

class ModernMoneyUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .motionShake {
            print("Shaked") }
        
    }
    
    func testLoginWithValidUserCredentials() {
        
        let loginPage = LoginPage()
        let enterPasswordPage = EnterPasswordPage()
        let enterPINPage = EnterPINPage()
        
        loginPage.tapYourEmailTextField()
        loginPage.enterEmail(email: "user@lykke.com")
        loginPage.tapSignInButton()
        
        enterPasswordPage.tapYourPasswordTextField()
        enterPasswordPage.enterPassword(password: "123456")
        enterPasswordPage.tapSignInButton()
        
        XCTAssertTrue(Page.app.staticTexts["ENTER PIN"].exists)
        
        enterPINPage.enterPIN(pin: "0000")
        
    //    XCTAssertTrue(elementsQuery.staticTexts["Please verify your login with an SMS code"].exists)
        
//        let codeTextField = elementsQuery.textFields["Code"]
//        codeTextField.tap()
//        codeTextField.typeText("0000")
//        elementsQuery.buttons["CONFIRM"].tap()
        
//        XCTAssertTrue(app.tables.buttons["VIEW ALL"].exists)
//        XCTAssertTrue(app.tables.buttons["CRYPTO CURRENCIES"].exists)
//        XCTAssertTrue(app.tables.buttons["FIAT CURRENCIES"].exists)
    }
    
    func testLoginWithInvalidUsername() {
        let loginPage = LoginPage()
        let enterPasswordPage = EnterPasswordPage()
        let page = Page()
        
        loginPage.typeYourEmailTextField.tap()
        loginPage.typeYourEmailTextField.typeText("invalid@user.test")
        loginPage.signInButton.tap()
        
        enterPasswordPage.tapYourPasswordTextField()
        enterPasswordPage.enterPassword(password: "querty")
        enterPasswordPage.tapSignInButton()
        
//        let errorAlert = Page.app.alerts["Error"]
//        XCTAssertTrue(errorAlert.staticTexts["Invalid username or password"].exists)
        
        XCTAssertTrue(page.isErrorAlert(alertText: "Invalid username or password"))
        page.closeErrorAlert()
        XCTAssertFalse(page.isErrorAlert(alertText: "Invalid username or password"))
    }
    
    func testLoginWithInvalidPassword() {
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        let typeYourEmailTextField = elementsQuery.textFields["Type your email"]
        typeYourEmailTextField.tap()
        typeYourEmailTextField.typeText("user@lykke.com")
        
        let signInButton = elementsQuery.buttons["SIGN IN"]
        signInButton.tap()
        
        let typeYourPasswordSecureTextField = elementsQuery.secureTextFields["Type your password"]
        typeYourPasswordSecureTextField.tap()
        typeYourPasswordSecureTextField.typeText("invpassword")
        signInButton.tap()
        
        let errorAlert = app.alerts["Error"]
        XCTAssertTrue(errorAlert.staticTexts["Invalid username or password"].exists)
        
        errorAlert.buttons["OK"].tap()
        XCTAssertFalse(errorAlert.exists)
    }
    
    func testEmailVerificationCodeMustBeValid(){
        
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["REGISTER"].tap()
        
        let typeYourEmailTextField = elementsQuery.textFields["Type your email"]
        typeYourEmailTextField.tap()
        typeYourEmailTextField.typeText("test.ver.code@test.com")
        
        
        let confirmButton = elementsQuery.buttons["CONFIRM"]
        confirmButton.tap()
        
        XCTAssertTrue(elementsQuery.staticTexts["We've sent the code to your email address test.ver.code@test.com"].exists)
        let codeTextField = elementsQuery.textFields["Code"]
        codeTextField.tap()
        codeTextField.typeText("1111")
        confirmButton.tap()
        
        let errorAlert = app.alerts["Error"]
        
        XCTAssertTrue(errorAlert.staticTexts["Invalid code. Please try again."].exists)
        errorAlert.buttons["OK"].tap()
        XCTAssertFalse(errorAlert.exists)
    }
    
    
    func testRegisterWithInvalidEmail() {
        // When email address is not valid COMFIRM button is disabled
        
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["REGISTER"].tap()
        
        let typeYourEmailTextField = elementsQuery.textFields["Type your email"]
        typeYourEmailTextField.tap()
        typeYourEmailTextField.typeText("invalid@email@.com")
        
        let confirmButton = elementsQuery.buttons["CONFIRM"]
        
        XCTAssertFalse(confirmButton.isEnabled)
    }
    
    func testRegistrationWhenEmailConfirmationCodeInNotValid() {
        /* Error message "Invalid code. Please try again." should appear on the screen when
        emai confirmation code is not valid. */
        
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["REGISTER"].tap()
        
        let typeYourEmailTextField = elementsQuery.textFields["Type your email"]
        typeYourEmailTextField.tap()
        typeYourEmailTextField.typeText("invalid@emailcode.com")
        
        let confirmButton = elementsQuery.buttons["CONFIRM"]
        confirmButton.tap()
        
        let codeTextField = elementsQuery.textFields["Code"]
        codeTextField.tap()
        codeTextField.typeText("0110")
        confirmButton.tap()
        
        let errorAlert = app.alerts["Error"]
        XCTAssertTrue(errorAlert.staticTexts["Invalid code. Please try again."].exists)
    }
    
    
    func testRegistrationWhenEmailConfirmationCodeIsLessThanFourDigits() {
        /* CONFIRM button should be displayed when the email confirmation code is less
         than four digits. */
        
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["REGISTER"].tap()
        
        let typeYourEmailTextField = elementsQuery.textFields["Type your email"]
        typeYourEmailTextField.tap()
        typeYourEmailTextField.typeText("invalid@emailcode.com")
        
        let confirmButton = elementsQuery.buttons["CONFIRM"]
        confirmButton.tap()
        
        let codeTextField = elementsQuery.textFields["Code"]
        codeTextField.tap()
        codeTextField.typeText("000")
        confirmButton.tap()
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
        XCTAssertFalse(confirmButton.isEnabled)
    }
    
    
    func testRegistration() {
        
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["REGISTER"].tap()
        
        let typeYourEmailTextField = elementsQuery.textFields["Type your email"]
        typeYourEmailTextField.tap()
        typeYourEmailTextField.typeText("new2@reg.com")
        
        let confirmButton = elementsQuery.buttons["CONFIRM"]
        confirmButton.tap()
        
        let codeTextField = elementsQuery.textFields["Code"]
        codeTextField.tap()
        codeTextField.typeText("0000")
        confirmButton.tap()
        
        let enterAPasswordSecureTextField = elementsQuery.secureTextFields["Enter a password"]
        enterAPasswordSecureTextField.tap()
        enterAPasswordSecureTextField.typeText("1234567")
        
        let enterAgainSecureTextField = elementsQuery.secureTextFields["Enter again"]
        enterAgainSecureTextField.tap()
        enterAgainSecureTextField.tap()
        enterAgainSecureTextField.typeText("1234567")
        
        let nextButton = elementsQuery.buttons["NEXT"]
        nextButton.tap()
        
        let enterAHintTextField = elementsQuery.textFields["Enter a hint"]
        enterAHintTextField.tap()
        enterAHintTextField.typeText("hunt")
        nextButton.tap()
        
        let firstNameTextField = elementsQuery.textFields["First name"]
        firstNameTextField.tap()
        firstNameTextField.typeText("testu")
        
        let lastNameTextField = elementsQuery.textFields["Last name"]
        lastNameTextField.tap()
        lastNameTextField.tap()
        lastNameTextField.typeText("user")
        nextButton.tap()
        
        let phoneNumberTextField = elementsQuery.textFields["Phone number"]
        phoneNumberTextField.tap()
        phoneNumberTextField.typeText("+3591110019")
        elementsQuery.buttons["SUBMIT"].tap()
        codeTextField.tap()
        codeTextField.tap()
        codeTextField.typeText("0000")
        confirmButton.tap()
        
        let button = app.buttons["0"]
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        
        
        //        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
        //        element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
        //
        //        let totalValue000UsdYourPortfolioIsEmptyAddMoneyToGetStartedTable = app.tables["TOTAL VALUE, $0.00, USD, YOUR PORTFOLIO IS EMPTY, Add money to get started."]
        //        totalValue000UsdYourPortfolioIsEmptyAddMoneyToGetStartedTable.tap()
        //        totalValue000UsdYourPortfolioIsEmptyAddMoneyToGetStartedTable.tap()
        //
        //        let element2 = element.children(matching: .other).element(boundBy: 0)
        //        element2.tap()
        //        element2.tap()
        //        totalValue000UsdYourPortfolioIsEmptyAddMoneyToGetStartedTable.tap()
        //        element2.tap()
        //        element2.tap()
        //        element2.tap()
        //        totalValue000UsdYourPortfolioIsEmptyAddMoneyToGetStartedTable.tap()
        //        totalValue000UsdYourPortfolioIsEmptyAddMoneyToGetStartedTable.tap()
        //        totalValue000UsdYourPortfolioIsEmptyAddMoneyToGetStartedTable.tap()
        //        totalValue000UsdYourPortfolioIsEmptyAddMoneyToGetStartedTable.tap()
        //        totalValue000UsdYourPortfolioIsEmptyAddMoneyToGetStartedTable.tap()
        //        totalValue000UsdYourPortfolioIsEmptyAddMoneyToGetStartedTable.tap()
        //
    }
    
}

