//
//  LoginUITests.swift
//  ModernMoneyUITests
//
//  Created by Radi Dichev on 11.05.18.
//  Copyright © 2018 Lykkex. All rights reserved.
//

import XCTest
class LoginUITests: XCTestCase {
    
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
    
    func testLoginWithValidUserCredentials() {
        // After login user is sent to Portfolio screen.
        
        let loginPage = LoginPage()
        let enterPasswordPage = EnterPasswordPage()
        let enterPINPage = EnterPINPage()
        let enterSMSCodePage = EnterSMSCodePage()
        let portfolioPage = PortfolioPage()
        
        loginPage.tapYourEmailTextField()
        loginPage.enterEmail(email: "user@lykke.com")
        loginPage.tapSignInButton()
        
        enterPasswordPage.tapYourPasswordTextField()
        enterPasswordPage.enterPassword(password: "123456")
        enterPasswordPage.tapSignInButton()
        
        XCTAssertTrue(Page.app.staticTexts["ENTER PIN"].exists)
        
        enterPINPage.enterPIN(pin: "0000")
        
        //    XCTAssertTrue(elementsQuery.staticTexts["Please verify your login with an SMS code"].exists)
        
        enterSMSCodePage.tapCodeField()
        enterSMSCodePage.enterCode(code: "0000")
        enterSMSCodePage.tapConfirnButton()
        
        XCTAssertTrue(portfolioPage.viewAllButton.exists)
        XCTAssertTrue(portfolioPage.cryptoCurrenciesButton.exists)
        XCTAssertTrue(portfolioPage.fiatCurrencies.exists)
    }
    
    func testLoginWithInvalidUsername() {
        // Error message  "Invalid username or password" appears when the username is not valid
        let loginPage = LoginPage()
        let enterPasswordPage = EnterPasswordPage()
        let page = Page()
        
        loginPage.tapYourEmailTextField()
        loginPage.enterEmail(email: "invalid@user.test")
        loginPage.tapSignInButton()
        
        enterPasswordPage.tapYourPasswordTextField()
        enterPasswordPage.enterPassword(password: "querty")
        enterPasswordPage.tapSignInButton()
        
        XCTAssertTrue(page.isErrorAlert(alertText: "Invalid username or password"))
        page.closeErrorAlert()
        XCTAssertFalse(page.isErrorAlert(alertText: "Invalid username or password"))
    }
    
    func testLoginWithInvalidPassword() {
        // Error message  "Invalid username or password" appears when the password is not valid
        
        let loginPage = LoginPage()
        let enterPasswordPage = EnterPasswordPage()
        let page = Page()
        
        loginPage.tapYourEmailTextField()
        loginPage.enterEmail(email: "user@lykke.com")
        loginPage.tapSignInButton()
        
        enterPasswordPage.tapYourPasswordTextField()
        enterPasswordPage.enterPassword(password: "querty")
        enterPasswordPage.tapSignInButton()
        
        XCTAssertTrue(page.isErrorAlert(alertText: "Invalid username or password"))
        page.closeErrorAlert()
        XCTAssertFalse(page.isErrorAlert(alertText: "Invalid username or password"))
    }
    
    func testLoginWhenSMSCodeIsNotValid() {
        // Error message "Wrong confirmation code" appears when the SMS confirmation code is not valid
        
        let loginPage = LoginPage()
        let enterPasswordPage = EnterPasswordPage()
        let enterPINPage = EnterPINPage()
        let enterSMSCodePage = EnterSMSCodePage()
        let page = Page()
        
        loginPage.tapYourEmailTextField()
        loginPage.enterEmail(email: "g30@g.com")
        loginPage.tapSignInButton()
        
        enterPasswordPage.tapYourPasswordTextField()
        enterPasswordPage.enterPassword(password: "123456")
        enterPasswordPage.tapSignInButton()
        
        XCTAssertTrue(Page.app.staticTexts["ENTER PIN"].exists)
        
        enterPINPage.enterPIN(pin: "0000")
        
        enterSMSCodePage.tapCodeField()
        enterSMSCodePage.enterCode(code: "2121")
        enterSMSCodePage.tapConfirnButton()
        
        XCTAssertTrue(page.isErrorAlert(alertText: "Wrong confirmation code"))
        page.closeErrorAlert()
        XCTAssertFalse(page.isErrorAlert(alertText: "Wrong confirmation code"))
    }
    
    func testLoginSMSBlockedUser() {
        /* "Error! Please contact support: support@lykke.com" message appears on the screen when blocked user tries to login */
        
        let loginPage = LoginPage()
        let enterPasswordPage = EnterPasswordPage()
        let enterPINPage = EnterPINPage()
        let enterSMSCodePage = EnterSMSCodePage()
        let page = Page()
        
        loginPage.tapYourEmailTextField()
        loginPage.enterEmail(email: "sms@blockeduser.com")
        loginPage.tapSignInButton()
        
        enterPasswordPage.tapYourPasswordTextField()
        enterPasswordPage.enterPassword(password: "123456")
        enterPasswordPage.tapSignInButton()
        
        XCTAssertTrue(Page.app.staticTexts["ENTER PIN"].exists)
        
        enterPINPage.enterPIN(pin: "0000")

        enterSMSCodePage.tapCodeField()
        enterSMSCodePage.enterCode(code: "0000")
        enterSMSCodePage.tapConfirnButton()
        
        XCTAssertTrue(page.isErrorAlert(alertText: "Error! Please contact support: support@lykke.com"))
        page.closeErrorAlert()
        XCTAssertFalse(page.isErrorAlert(alertText: "Error! Please contact support: support@lykke.com"))
    }
    
    func testLoginPINBlockedUser() {
        /* "Error! Please contact support: support@lykke.com" message appears on the screen when blocked user tries to login */
        
        let loginPage = LoginPage()
        let enterPasswordPage = EnterPasswordPage()
        let enterPINPage = EnterPINPage()
        let page = Page()
        
        loginPage.tapYourEmailTextField()
        loginPage.enterEmail(email: "pin@blockeduser.com")
        loginPage.tapSignInButton()
        
        enterPasswordPage.tapYourPasswordTextField()
        enterPasswordPage.enterPassword(password: "123456")
        enterPasswordPage.tapSignInButton()
        
        XCTAssertTrue(Page.app.staticTexts["ENTER PIN"].exists)
        
        enterPINPage.enterPIN(pin: "0000")
        
        XCTAssertTrue(page.isErrorAlert(alertText: "Error! Please contact support: support@lykke.com"))
        page.closeErrorAlert()
        XCTAssertFalse(page.isErrorAlert(alertText: "Error! Please contact support: support@lykke.com"))
    }
}
