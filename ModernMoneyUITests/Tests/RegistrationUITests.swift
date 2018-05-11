//
//  RegistrationUITests.swift
//  ModernMoneyUITests
//
//  Created by Radi Dichev on 11.05.18.
//  Copyright © 2018 Lykkex. All rights reserved.
//

import XCTest
class RegistrationUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        UserDefaults.standard.set(nil, forKey: "SingUpStep")
        UserDefaults.standard.synchronize()
        
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()
        
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        let sideNavBar = SideNavBar()
            if sideNavBar.menuIcon.exists {
            sideNavBar.open()
            sideNavBar.selectMenuItem(item: "LOGOUT")
        }
        
    }
    
    func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .motionShake {
            print("Shaked") }
    }
    
    func testRegistrationWhenEmailConfirmationCodeInNotValid(){
        // Error message "Invalid code. Please try again." appears when the Email Verificaion Code is not valid.
        
        let loginPage = LoginPage()
        let registrationEmailPage = RegistrationEmailPage()
        let registrationEnterEmailValidationCodePage = RegistrationEnterEmailValidationCodePage()
        let page = Page()
        
        loginPage.tapRegisterButton()
        
        registrationEmailPage.tapYourEmailTextField()
        registrationEmailPage.enterEmail(email: "test.ver.code@test.com")
        registrationEmailPage.tapConfirmnButton()
        
        // XCTAssertTrue(elementsQuery.staticTexts["We've sent the code to your email address test.ver.code@test.com"].exists)
        
        registrationEnterEmailValidationCodePage.tapCodeField()
        registrationEnterEmailValidationCodePage.enterCode(code: "1111")
        registrationEnterEmailValidationCodePage.tapConfirmButton()
        
        XCTAssertTrue(page.isErrorAlert(alertText: "Invalid code. Please try again."))
        page.closeErrorAlert()
        XCTAssertFalse(page.isErrorAlert(alertText: "Invalid code. Please try again."))
    }
    
    func testRegisterWithInvalidEmail() {
        // When email address is not valid COMFIRM button is disabled
        
        let loginPage = LoginPage()
        let registrationEmailPage = RegistrationEmailPage()
        
        loginPage.tapRegisterButton()
        
        registrationEmailPage.tapYourEmailTextField()
        registrationEmailPage.enterEmail(email: "invalid@email@.com")
        
        XCTAssertFalse(registrationEmailPage.confirmButton.isEnabled)
    }
    
    func testRegistrationWhenEmailConfirmationCodeIsLessThanFourDigits() {
        /* CONFIRM button should be displayed when the email confirmation code is less
         than four digits. */
        
        let loginPage = LoginPage()
        let registrationEmailPage = RegistrationEmailPage()
        let registrationEnterEmailValidationCodePage = RegistrationEnterEmailValidationCodePage()
        
        loginPage.tapRegisterButton()
        
        registrationEmailPage.tapYourEmailTextField()
        registrationEmailPage.enterEmail(email: "invalid@emailcode.com")
        registrationEmailPage.tapConfirmnButton()
        
        registrationEnterEmailValidationCodePage.tapCodeField()
        registrationEnterEmailValidationCodePage.enterCode(code: "000")
        registrationEnterEmailValidationCodePage.tapConfirmButton()
        
        XCTAssertFalse(registrationEnterEmailValidationCodePage.confirmButton.isEnabled)
    }
    
    
    func testRegistration() {
        
        let loginPage = LoginPage()
        let registrationEmailPage = RegistrationEmailPage()
        let registrationEnterEmailValidationCodePage = RegistrationEnterEmailValidationCodePage()
        let createPasswordPage = CreatePasswordPage()
        let enterHuntPage = EnterHuntPage()
        let completeProfilePage = CompleteProfilePage()
        let completeYourPhonePage = CompleteYourPhonePage()
        let enterPhoneCodePage = EnterPhoneCodePage()
        let createPINPage = CreatePINPage()
        let testData = TestData()
        
        let password = testData.password
        loginPage.tapRegisterButton()
        
        registrationEmailPage.tapYourEmailTextField()
        registrationEmailPage.enterEmail(email: testData.email)
        registrationEmailPage.tapConfirmnButton()
        
        registrationEnterEmailValidationCodePage.tapCodeField()
        registrationEnterEmailValidationCodePage.enterCode(code: "0000")
        registrationEnterEmailValidationCodePage.tapConfirmButton()
        
        createPasswordPage.tapEnterAPasswordSecureTextField()
        createPasswordPage.enterPassword(password: password)
        createPasswordPage.tapEnterAgainSecureTextField()
        createPasswordPage.enterPasswordAgain(password: password)
        createPasswordPage.tapNextButton()
        
        enterHuntPage.tapEnterAHuntTextField()
        enterHuntPage.enterHunt(hunt: testData.hunt)
        enterHuntPage.tapNextButton()
        
        completeProfilePage.tapFirstNameTextField()
        completeProfilePage.enterFirstName(firstName: testData.firstName)
        completeProfilePage.tapLastNameTextField()
        completeProfilePage.enterLastName(lastName: testData.lastName)
        completeProfilePage.tapNextButton()
        
        completeYourPhonePage.tapPhoneNumberTextField()
        completeYourPhonePage.enterPhoneNumber(phoneNumber: testData.phoneNumber)
        completeYourPhonePage.tapSubmitButton()
        
        enterPhoneCodePage.tapCodeField()
        enterPhoneCodePage.enterCode(code: "0000")
        enterPhoneCodePage.tapConfirmButton()
        
        createPINPage.enterPIN(pin: "0000")
        createPINPage.confirmPIN(pin: "0000")
        
        //TODO: Shake device gesture
        
        
        
        XCTAssertTrue(Page.app.tables["TOTAL VALUE, $0.00, USD, YOUR PORTFOLIO IS EMPTY, Add money to get started."].staticTexts["$0.00"].exists)
    }
    
    func testPasswordMustBeMinimumFiveSymbols() {
        // Password must be at least five symbols.
        
        let loginPage = LoginPage()
        let registrationEmailPage = RegistrationEmailPage()
        let registrationEnterEmailValidationCodePage = RegistrationEnterEmailValidationCodePage()
        let createPasswordPage = CreatePasswordPage()
        let testData = TestData()
        
        loginPage.tapRegisterButton()
        
        registrationEmailPage.tapYourEmailTextField()
        registrationEmailPage.enterEmail(email: testData.email)
        registrationEmailPage.tapConfirmnButton()
        
        registrationEnterEmailValidationCodePage.tapCodeField()
        registrationEnterEmailValidationCodePage.enterCode(code: "0000")
        registrationEnterEmailValidationCodePage.tapConfirmButton()
        
        createPasswordPage.tapEnterAPasswordSecureTextField()
        createPasswordPage.enterPassword(password: "1234")
        createPasswordPage.tapEnterAgainSecureTextField()
        createPasswordPage.enterPasswordAgain(password: "1234")
        
        XCTAssertFalse(createPasswordPage.nextButton.isEnabled)
    }
    
    func testRegistrationConfirmPassword() {
        /* When the password do not match "Next" button is disabled and the user is not able to
         continue with the registration. */
        
        let loginPage = LoginPage()
        let registrationEmailPage = RegistrationEmailPage()
        let registrationEnterEmailValidationCodePage = RegistrationEnterEmailValidationCodePage()
        let createPasswordPage = CreatePasswordPage()
        let testData = TestData()
        
        loginPage.tapRegisterButton()
        
        registrationEmailPage.tapYourEmailTextField()
        registrationEmailPage.enterEmail(email: testData.email)
        registrationEmailPage.tapConfirmnButton()
        
        registrationEnterEmailValidationCodePage.tapCodeField()
        registrationEnterEmailValidationCodePage.enterCode(code: "0000")
        registrationEnterEmailValidationCodePage.tapConfirmButton()
        
        createPasswordPage.tapEnterAPasswordSecureTextField()
        createPasswordPage.enterPassword(password: "123456")
        createPasswordPage.tapEnterAgainSecureTextField()
        createPasswordPage.enterPasswordAgain(password: "123457")
        
        XCTAssertFalse(createPasswordPage.nextButton.isEnabled)
    }
}


