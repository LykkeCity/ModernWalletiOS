import XCTest

class ModernMoneyUITests: XCTestCase {
    
    // let faker = Fakery(locale: "nb-NO")
    
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        XCUIApplication().launchArguments = ["-StartFromCleanState", "YES"]
        
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
        
        loginPage.tapRegisterButton()
        
        registrationEmailPage.tapYourEmailTextField()
        registrationEmailPage.enterEmail(email: "new104@email.com") //TODO: Generate new email for each test execution (Faker?)
        registrationEmailPage.tapConfirmnButton()
        
        registrationEnterEmailValidationCodePage.tapCodeField()
        registrationEnterEmailValidationCodePage.enterCode(code: "0000")
        registrationEnterEmailValidationCodePage.tapConfirmButton()
        
        createPasswordPage.tapEnterAPasswordSecureTextField()
        createPasswordPage.enterPassword(password: "123456")
        createPasswordPage.tapEnterAgainSecureTextField()
        createPasswordPage.enterPasswordAgain(password: "123456")
        createPasswordPage.tapNextButton()

        enterHuntPage.tapEnterAHuntTextField()
        enterHuntPage.enterHunt(hunt: "hunt")
        enterHuntPage.tapNextButton()
        
        completeProfilePage.tapFirstNameTextField()
        completeProfilePage.enterFirstName(firstName: "John")
        completeProfilePage.tapLastNameTextField()
        completeProfilePage.enterLastName(lastName: "Doe")
        completeProfilePage.tapNextButton()
       
        completeYourPhonePage.tapPhoneNumberTextField()
        completeYourPhonePage.enterPhoneNumber(phoneNumber: "+3599890080") //TODO: Generate new phone for each test execution (Faker?)
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
        
        loginPage.tapRegisterButton()
        
        registrationEmailPage.tapYourEmailTextField()
        registrationEmailPage.enterEmail(email: "testPsw2@email.com") //TODO: Generate new email for each test execution (Faker?)
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
        
        loginPage.tapRegisterButton()
        
        registrationEmailPage.tapYourEmailTextField()
        registrationEmailPage.enterEmail(email: "testPsw2@email.com") //TODO: Generate new email for each test execution (Faker?)
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

