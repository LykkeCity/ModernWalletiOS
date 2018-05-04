import XCTest
class ModernMoneyUITests: XCTestCase {
    
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
//
//        let sideNavBar = SideNavBar()
//        if sideNavBar.menuIcon.exists {
//            sideNavBar.open()
//            sideNavBar.selectMenuItem(item: "LOGOUT")
//        }
        
    }
   
    func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .motionShake {
            print("Shaked") }
    }
    
    func login(email: String, password: String, pin: String, smsCode: String) {
        let loginPage = LoginPage()
        let enterPasswordPage = EnterPasswordPage()
        let enterPINPage = EnterPINPage()
        let enterSMSCodePage = EnterSMSCodePage()
        
        loginPage.tapYourEmailTextField()
        loginPage.enterEmail(email: email)
        loginPage.tapSignInButton()
        
        enterPasswordPage.tapYourPasswordTextField()
        enterPasswordPage.enterPassword(password: password)
        enterPasswordPage.tapSignInButton()
        
        enterPINPage.enterPIN(pin: pin)
        
        enterSMSCodePage.tapCodeField()
        enterSMSCodePage.enterCode(code: smsCode)
        enterSMSCodePage.tapConfirnButton()
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
    
    func testPortfolioAddMoneyLink() {
        // Taping on "+Add Money" link on Portfolio page redirects to Add Money page.
        
        let loginPage = LoginPage()
        let enterPasswordPage = EnterPasswordPage()
        let enterPINPage = EnterPINPage()
        let enterSMSCodePage = EnterSMSCodePage()
        let portfolioPage = PortfolioPage()
        
        loginPage.tapYourEmailTextField()
        loginPage.enterEmail(email: "radi.dichev@primeholding.com")
        loginPage.tapSignInButton()
        
        enterPasswordPage.tapYourPasswordTextField()
        enterPasswordPage.enterPassword(password: "123456")
        enterPasswordPage.tapSignInButton()
        
        XCTAssertTrue(Page.app.staticTexts["ENTER PIN"].exists)
        
        enterPINPage.enterPIN(pin: "0000")
                
        enterSMSCodePage.tapCodeField()
        enterSMSCodePage.enterCode(code: "0000")
        enterSMSCodePage.tapConfirnButton()
        
        portfolioPage.tapAddMoneyLink()
        
        XCTAssertTrue(Page.app.staticTexts["TOTAL VALUE"].exists)
        XCTAssertTrue(Page.app.staticTexts["ADD MONEY FROM"].exists)
    }
    
    func testPortfolioOpenAssetDetailsPage() {
        // Asset details page opens when user taps on currency.
        
        let loginPage = LoginPage()
        let enterPasswordPage = EnterPasswordPage()
        let enterPINPage = EnterPINPage()
        let enterSMSCodePage = EnterSMSCodePage()
        let portfolioPage = PortfolioPage()
        
        loginPage.tapYourEmailTextField()
        loginPage.enterEmail(email: "radi.dichev@primeholding.com")
        loginPage.tapSignInButton()
        
        enterPasswordPage.tapYourPasswordTextField()
        enterPasswordPage.enterPassword(password: "123456")
        enterPasswordPage.tapSignInButton()
        
        XCTAssertTrue(Page.app.staticTexts["ENTER PIN"].exists)
        
        enterPINPage.enterPIN(pin: "0000")
        
        enterSMSCodePage.tapCodeField()
        enterSMSCodePage.enterCode(code: "0000")
        enterSMSCodePage.tapConfirnButton()
        
        portfolioPage.tapOnCurrency(currency: "EUR")
        
        XCTAssertTrue(Page.app.staticTexts["EUR"].exists)
        XCTAssertTrue(Page.app.staticTexts["TOTAL VALUE"].exists)
        XCTAssertTrue(Page.app.staticTexts["TRANSACTIONS"].exists)
    }
    
    func testChangeBaseAsset() {
        // User is able to change tha base asset
        let sideNavBar = SideNavBar()
        let settingsPage = SettingsPage()
        let portfolioPage = PortfolioPage()
        
        login(email: "user@lykke.com", password: "123456", pin: "0000", smsCode: "0000")
        let baseAsset = portfolioPage.getTotalBalanceAmount().first
        let newBaseAsset = "BTC"
        settingsPage.open()
        /* TODO: We have to check for the currently selected asset before change the it */
        settingsPage.selectBaseAsset(baseAsset: newBaseAsset)
        sideNavBar.open()
        sideNavBar.selectMenuItem(item: "PORTFOLIO")
        XCTAssertNotEqual(portfolioPage.getTotalBalanceAmount().first, baseAsset)
    }
    
    
    func testPortfolioViewOnlyCryptoCurrrencies() {
        /* Filter only cryptocurrencies and make sure that the correct currencies are
         listed in the table below */
        
        let portfolioPage = PortfolioPage()
        let expectedNunberOfRecords = 4
        let expectedCurrencies = ["LKK", "ETH", "SLR", "BTC"]
       
        login(email: "user@lykke.com", password: "123456", pin: "0000", smsCode: "0000")
        
        portfolioPage.showOnlyCryptoCurrencies()
        portfolioPage.swipeTableUp()
        XCTAssertTrue(portfolioPage.getTableRowCount() == expectedNunberOfRecords)
        XCTAssertTrue(portfolioPage.portfolioTable.staticTexts[expectedCurrencies[0]].exists)
        XCTAssertTrue(portfolioPage.portfolioTable.staticTexts[expectedCurrencies[1]].exists)
        XCTAssertTrue(portfolioPage.portfolioTable.staticTexts[expectedCurrencies[2]].exists)
        XCTAssertTrue(portfolioPage.portfolioTable.staticTexts[expectedCurrencies[3]].exists)
    }
        
    
    
    func testPortfolioViewOnlyFiatCurrrencies() {
        /* Filter only fiat currencies and make sure that the correct currencies are
         listed in the table below */
        
        let portfolioPage = PortfolioPage()
        let expectedNunberOfRecords = 3
        let expectedCurrencies = ["USD", "EUR", "CHF"]
        
        login(email: "user@lykke.com", password: "123456", pin: "0000", smsCode: "0000")
        
        portfolioPage.showOnlyFiatCurrencies()
        portfolioPage.swipeTableUp()
        XCTAssertTrue(portfolioPage.getTableRowCount() == expectedNunberOfRecords)
        XCTAssertTrue(portfolioPage.portfolioTable.staticTexts[expectedCurrencies[0]].exists)
        XCTAssertTrue(portfolioPage.portfolioTable.staticTexts[expectedCurrencies[1]].exists)
        XCTAssertTrue(portfolioPage.portfolioTable.staticTexts[expectedCurrencies[2]].exists)
        XCTAssertTrue(portfolioPage.portfolioTable.staticTexts[expectedCurrencies[3]].exists)
    }
    
    func testPortfolioViewAllCurrrencies() {
        /* Make sure that all currencies are listed in the table below */
        
        let portfolioPage = PortfolioPage()
        let expectedNunberOfRecords = 7
        let expectedCurrencies = ["USD", "EUR", "CHF", "LKK", "ETH", "SLR", "BTC"]
        
        login(email: "user@lykke.com", password: "123456", pin: "0000", smsCode: "0000")
        
        portfolioPage.swipeTableUp()
        XCTAssertTrue(portfolioPage.getTableRowCount() == expectedNunberOfRecords)
        XCTAssertTrue(portfolioPage.portfolioTable.staticTexts[expectedCurrencies[0]].exists)
        XCTAssertTrue(portfolioPage.portfolioTable.staticTexts[expectedCurrencies[1]].exists)
        XCTAssertTrue(portfolioPage.portfolioTable.staticTexts[expectedCurrencies[2]].exists)
        XCTAssertTrue(portfolioPage.portfolioTable.staticTexts[expectedCurrencies[3]].exists)
        XCTAssertTrue(portfolioPage.portfolioTable.staticTexts[expectedCurrencies[4]].exists)
        XCTAssertTrue(portfolioPage.portfolioTable.staticTexts[expectedCurrencies[5]].exists)
        XCTAssertTrue(portfolioPage.portfolioTable.staticTexts[expectedCurrencies[6]].exists)
        XCTAssertTrue(portfolioPage.portfolioTable.staticTexts[expectedCurrencies[7]].exists)
    }
    
    func testSendReceiveButtonsDisabledForFiatCurrencies() {
        // Send and Receive Buttons on assert details page are disabled for fiat currencies
        
        let portfolioPage = PortfolioPage()
        let assetDetailsPage = AssetDetailsPage()
       
        login(email: "user@lykke.com", password: "123456", pin: "0000", smsCode: "0000")
        
        portfolioPage.showOnlyFiatCurrencies()
        portfolioPage.tapOnCurrency(currency: "EUR")
        
        XCTAssertFalse(assetDetailsPage.sendButton.isEnabled)
        XCTAssertFalse(assetDetailsPage.receiveButton.isEnabled)
    }
    
    func testSubmitAddMoneyFromCreditCard() {
        // Add Money Form CC order is submited successfully when all data is filled successfully
        
        let addMoneyPage = AddMoneyPage()
        let addMoneyFromCrediCardPage = AddMoneyFromCreditCardPage()
        let testData = TestData()
        
        addMoneyPage.open()
        addMoneyPage.selectCreditCardOption()
        addMoneyPage.selectCurrency(currency: "EUR")
        XCTAssertTrue(addMoneyFromCrediCardPage.getAmount() == "00.00")
        print(addMoneyFromCrediCardPage.getAssetSymbol())
        // XCTAssertTrue(addMoneyFromCrediCardPage.getAssetSymbol() == "€")

        print(addMoneyFromCrediCardPage.getAssetCode())
        // XCTAssertTrue(addMoneyFromCrediCardPage.getAssetCode() == "EUR")
        
        addMoneyFromCrediCardPage.enterAmount(amount: "10.5")
        addMoneyFromCrediCardPage.enterFirstName(firstName: testData.firstName)
        addMoneyFromCrediCardPage.enterLastName(lastName: testData.lastName)
        addMoneyFromCrediCardPage.enterAddress(address: testData.street)
        addMoneyFromCrediCardPage.enterCity(city: testData.city)
        addMoneyFromCrediCardPage.enterZip(zip: testData.zipCode)
        addMoneyFromCrediCardPage.enterCounty(country: testData.country)
        addMoneyFromCrediCardPage.enterPhoneCode(code: "+123")
        addMoneyFromCrediCardPage.enterPhone(phone: "2000020")
        addMoneyFromCrediCardPage.tapSubmit()
        // TODO:
        
  }
    
    func testFieldAmountShouldNotBeEmpty() {
        // When the user submit the order with amount value 00.00, error message "Field Amount should not be empty" appear on the screen
        
        let addMoneyPage = AddMoneyPage()
        let addMoneyFromCrediCardPage = AddMoneyFromCreditCardPage()
        let testData = TestData()
        
        addMoneyPage.open()
        addMoneyPage.selectCreditCardOption()
        addMoneyPage.selectCurrency(currency: "EUR")
        XCTAssertTrue(addMoneyFromCrediCardPage.getAmount() == "00.00")
        addMoneyFromCrediCardPage.enterFirstName(firstName: testData.firstName)
        addMoneyFromCrediCardPage.enterLastName(lastName: testData.lastName)
        addMoneyFromCrediCardPage.enterAddress(address: testData.street)
        addMoneyFromCrediCardPage.enterCity(city: testData.city)
        addMoneyFromCrediCardPage.enterZip(zip: testData.zipCode)
        addMoneyFromCrediCardPage.enterCounty(country: testData.country)
        addMoneyFromCrediCardPage.enterPhoneCode(code: "+123")
        addMoneyFromCrediCardPage.enterPhone(phone: "2000020")
        addMoneyFromCrediCardPage.tapSubmit()
        XCTAssertTrue(addMoneyFromCrediCardPage.emptyAmountErrMessage.exists)
    }
    
    func testFirstNameFieldShouldNotBeEmpty() {
        // First Name field is requred and cannot be empty.
        
        let addMoneyPage = AddMoneyPage()
        let addMoneyFromCrediCardPage = AddMoneyFromCreditCardPage()
        let testData = TestData()
        
        addMoneyPage.open()
        addMoneyPage.selectCreditCardOption()
        addMoneyPage.selectCurrency(currency: "EUR")
        XCTAssertTrue(addMoneyFromCrediCardPage.getAmount() == "00.00")
        addMoneyFromCrediCardPage.enterAmount(amount: "10.5")
        addMoneyFromCrediCardPage.enterFirstName(firstName: " ")
        addMoneyFromCrediCardPage.enterLastName(lastName: testData.lastName)
        addMoneyFromCrediCardPage.enterAddress(address: testData.street)
        addMoneyFromCrediCardPage.enterCity(city: testData.city)
        addMoneyFromCrediCardPage.enterZip(zip: testData.zipCode)
        addMoneyFromCrediCardPage.enterCounty(country: testData.country)
        addMoneyFromCrediCardPage.enterPhoneCode(code: "+123")
        addMoneyFromCrediCardPage.enterPhone(phone: "2000020")
        addMoneyFromCrediCardPage.tapSubmit()
        XCTAssertTrue(Page.app.staticTexts["Field First Name should not be empty"].exists)
    }
    
    func testLastNameFieldShouldNotBeEmpty() {
        // Last Name field is requred and cannot be empty.
        
        let addMoneyPage = AddMoneyPage()
        let addMoneyFromCrediCardPage = AddMoneyFromCreditCardPage()
        let testData = TestData()
        
        addMoneyPage.open()
        addMoneyPage.selectCreditCardOption()
        addMoneyPage.selectCurrency(currency: "EUR")
        XCTAssertTrue(addMoneyFromCrediCardPage.getAmount() == "00.00")
        addMoneyFromCrediCardPage.enterAmount(amount: "10.5")
        addMoneyFromCrediCardPage.enterFirstName(firstName: testData.lastName)
        addMoneyFromCrediCardPage.enterLastName(lastName: " ")
        addMoneyFromCrediCardPage.enterAddress(address: testData.street)
        addMoneyFromCrediCardPage.enterCity(city: testData.city)
        addMoneyFromCrediCardPage.enterZip(zip: testData.zipCode)
        addMoneyFromCrediCardPage.enterCounty(country: testData.country)
        addMoneyFromCrediCardPage.enterPhoneCode(code: "+123")
        addMoneyFromCrediCardPage.enterPhone(phone: "2000020")
        addMoneyFromCrediCardPage.tapSubmit()
        XCTAssertTrue(Page.app.staticTexts["Field Last Name should not be empty"].exists)
    }


}

