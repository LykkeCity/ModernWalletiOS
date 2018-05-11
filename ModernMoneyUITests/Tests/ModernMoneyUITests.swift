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
       
        // login(email: "user@lykke.com", password: "123456", pin: "0000", smsCode: "0000")
        
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
        
        //login(email: "user@lykke.com", password: "123456", pin: "0000", smsCode: "0000")
        
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
       
       // login(email: "user@lykke.com", password: "123456", pin: "0000", smsCode: "0000")
        
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
        addMoneyFromCrediCardPage.enterFirstName(firstName: "")
        addMoneyFromCrediCardPage.enterLastName(lastName: testData.lastName)
        addMoneyFromCrediCardPage.enterAddress(address: testData.street)
        addMoneyFromCrediCardPage.enterCity(city: testData.city)
        addMoneyFromCrediCardPage.enterZip(zip: testData.zipCode)
        addMoneyFromCrediCardPage.enterCounty(country: testData.country)
        addMoneyFromCrediCardPage.enterPhoneCode(code: "+123")
        addMoneyFromCrediCardPage.enterPhone(phone: "2000020")
        addMoneyFromCrediCardPage.tapDone()
        XCTAssertTrue(Page.app.staticTexts["Field First Name should not be empty"].exists) // Fails because of LMW-459
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
        addMoneyFromCrediCardPage.enterFirstName(firstName: testData.firstName)
        addMoneyFromCrediCardPage.enterLastName(lastName: "")
        addMoneyFromCrediCardPage.enterAddress(address: testData.street)
        addMoneyFromCrediCardPage.enterCity(city: testData.city)
        addMoneyFromCrediCardPage.enterZip(zip: testData.zipCode)
        addMoneyFromCrediCardPage.enterCounty(country: testData.country)
        addMoneyFromCrediCardPage.enterPhoneCode(code: "+123")
        addMoneyFromCrediCardPage.enterPhone(phone: "2000020")
        addMoneyFromCrediCardPage.tapDone()
        XCTAssertTrue(Page.app.staticTexts["Field Last Name should not be empty"].exists) // Fails because of LMW-459
    }

    func testAddressFieldShouldNotBeEmpty() {
        // Address field is requred and cannot be empty.
        
        let addMoneyPage = AddMoneyPage()
        let addMoneyFromCrediCardPage = AddMoneyFromCreditCardPage()
        let testData = TestData()
        
        addMoneyPage.open()
        addMoneyPage.selectCreditCardOption()
        addMoneyPage.selectCurrency(currency: "EUR")
        XCTAssertTrue(addMoneyFromCrediCardPage.getAmount() == "00.00")
        addMoneyFromCrediCardPage.enterAmount(amount: "10.5")
        addMoneyFromCrediCardPage.enterFirstName(firstName: testData.firstName)
        addMoneyFromCrediCardPage.enterLastName(lastName: testData.lastName)
        addMoneyFromCrediCardPage.enterAddress(address: "")
        addMoneyFromCrediCardPage.enterCity(city: testData.city)
        addMoneyFromCrediCardPage.enterZip(zip: testData.zipCode)
        addMoneyFromCrediCardPage.enterCounty(country: testData.country)
        addMoneyFromCrediCardPage.enterPhoneCode(code: "+123")
        addMoneyFromCrediCardPage.enterPhone(phone: "2000020")
        addMoneyFromCrediCardPage.tapDone()
        XCTAssertTrue(Page.app.staticTexts["Field Address should not be empty"].exists)
    }
    
    
    func testCityFieldShouldNotBeEmpty() {
        // City field is requred and cannot be empty.
        
        let addMoneyPage = AddMoneyPage()
        let addMoneyFromCrediCardPage = AddMoneyFromCreditCardPage()
        let testData = TestData()
        
        addMoneyPage.open()
        addMoneyPage.selectCreditCardOption()
        addMoneyPage.selectCurrency(currency: "EUR")
        XCTAssertTrue(addMoneyFromCrediCardPage.getAmount() == "00.00")
        addMoneyFromCrediCardPage.enterAmount(amount: "10.5")
        addMoneyFromCrediCardPage.enterFirstName(firstName: testData.firstName)
        addMoneyFromCrediCardPage.enterLastName(lastName: testData.lastName)
        addMoneyFromCrediCardPage.enterAddress(address: testData.street)
        addMoneyFromCrediCardPage.enterCity(city: "")
        addMoneyFromCrediCardPage.enterZip(zip: testData.zipCode)
        addMoneyFromCrediCardPage.enterCounty(country: testData.country)
        addMoneyFromCrediCardPage.enterPhoneCode(code: "+123")
        addMoneyFromCrediCardPage.enterPhone(phone: "2000020")
        addMoneyFromCrediCardPage.tapDone()
        XCTAssertTrue(Page.app.staticTexts["Field City should not be empty"].exists)
    }
    
    func testZipFieldShouldNotBeEmpty() {
        // Zip field is requred and cannot be empty.
        
        let addMoneyPage = AddMoneyPage()
        let addMoneyFromCrediCardPage = AddMoneyFromCreditCardPage()
        let testData = TestData()
        
        addMoneyPage.open()
        addMoneyPage.selectCreditCardOption()
        addMoneyPage.selectCurrency(currency: "EUR")
        XCTAssertTrue(addMoneyFromCrediCardPage.getAmount() == "00.00")
        addMoneyFromCrediCardPage.enterAmount(amount: "10.5")
        addMoneyFromCrediCardPage.enterFirstName(firstName: testData.firstName)
        addMoneyFromCrediCardPage.enterLastName(lastName: testData.lastName)
        addMoneyFromCrediCardPage.enterAddress(address: testData.street)
        addMoneyFromCrediCardPage.enterCity(city: testData.city)
        addMoneyFromCrediCardPage.enterZip(zip: "")
        addMoneyFromCrediCardPage.enterCounty(country: testData.country)
        addMoneyFromCrediCardPage.enterPhoneCode(code: "+123")
        addMoneyFromCrediCardPage.enterPhone(phone: "2000020")
        addMoneyFromCrediCardPage.tapDone()
        XCTAssertTrue(Page.app.staticTexts["Field Zip should not be empty"].exists)
    }
    
    func testPhoneNumberFieldShouldNotBeEmpty() {
        // Phone Number field is requred and cannot be empty.
        
        let addMoneyPage = AddMoneyPage()
        let addMoneyFromCrediCardPage = AddMoneyFromCreditCardPage()
        let testData = TestData()
        
        addMoneyPage.open()
        addMoneyPage.selectCreditCardOption()
        addMoneyPage.selectCurrency(currency: "EUR")
        XCTAssertTrue(addMoneyFromCrediCardPage.getAmount() == "00.00")
        addMoneyFromCrediCardPage.enterAmount(amount: "10.5")
        addMoneyFromCrediCardPage.enterFirstName(firstName: testData.firstName)
        addMoneyFromCrediCardPage.enterLastName(lastName: testData.lastName)
        addMoneyFromCrediCardPage.enterAddress(address: testData.street)
        addMoneyFromCrediCardPage.enterCity(city: testData.city)
        addMoneyFromCrediCardPage.enterZip(zip: testData.zipCode)
        addMoneyFromCrediCardPage.enterCounty(country: testData.country)
        addMoneyFromCrediCardPage.enterPhoneCode(code: "")
        addMoneyFromCrediCardPage.enterPhone(phone: "")
        addMoneyFromCrediCardPage.tapDone()
        XCTAssertTrue(Page.app.staticTexts["Field Phone should not be empty"].exists)
    }
    
    func testAddMoneyFromCCWhenAmmountExceedsCCDepositLimit() {
        // Error message appears when the user tries to submit the form but the entered amount exceeds the credit card deposit limit
        
        let addMoneyPage = AddMoneyPage()
        let addMoneyFromCrediCardPage = AddMoneyFromCreditCardPage()
        let testData = TestData()
        
        addMoneyPage.open()
        addMoneyPage.selectCreditCardOption()
        addMoneyPage.selectCurrency(currency: "EUR")
        XCTAssertTrue(addMoneyFromCrediCardPage.getAmount() == "00.00")
        addMoneyFromCrediCardPage.enterAmount(amount: "3001")
        addMoneyFromCrediCardPage.enterFirstName(firstName: testData.firstName)
        addMoneyFromCrediCardPage.enterLastName(lastName: testData.lastName)
        addMoneyFromCrediCardPage.enterAddress(address: testData.street)
        addMoneyFromCrediCardPage.enterCity(city: testData.city)
        addMoneyFromCrediCardPage.enterZip(zip: testData.zipCode)
        addMoneyFromCrediCardPage.enterCounty(country: testData.country)
        addMoneyFromCrediCardPage.enterPhoneCode(code: "+123")
        addMoneyFromCrediCardPage.enterPhone(phone: "2000020")
        addMoneyFromCrediCardPage.tapDone()
        XCTAssertTrue(Page.app.staticTexts["The credit card deposit limit is EUR 3000"].exists)
    }
    
    func testOrderAmountShouldBeGreaterThan8() {
        // Test for minimal order amount
        
        let addMoneyPage = AddMoneyPage()
        let addMoneyFromCrediCardPage = AddMoneyFromCreditCardPage()
        let testData = TestData()
        
        addMoneyPage.open()
        addMoneyPage.selectCreditCardOption()
        addMoneyPage.selectCurrency(currency: "USD")
        XCTAssertTrue(addMoneyFromCrediCardPage.getAmount() == "00.00")
        addMoneyFromCrediCardPage.enterAmount(amount: "7.99")
        addMoneyFromCrediCardPage.enterFirstName(firstName: testData.firstName)
        addMoneyFromCrediCardPage.enterLastName(lastName: testData.lastName)
        addMoneyFromCrediCardPage.enterAddress(address: testData.street)
        addMoneyFromCrediCardPage.enterCity(city: testData.city)
        addMoneyFromCrediCardPage.enterZip(zip: testData.zipCode)
        addMoneyFromCrediCardPage.enterCounty(country: testData.country)
        addMoneyFromCrediCardPage.enterPhoneCode(code: "+123")
        addMoneyFromCrediCardPage.enterPhone(phone: "2000020")
        addMoneyFromCrediCardPage.tapDone()
        XCTAssertTrue(Page.app.staticTexts["The order amount should be greater than USD 8"].exists)
    }
    
    func testPhoneNumberShouldBeValid() {
        // Test with invalid phone number
        
        let addMoneyPage = AddMoneyPage()
        let addMoneyFromCrediCardPage = AddMoneyFromCreditCardPage()
        let testData = TestData()
        
        addMoneyPage.open()
        addMoneyPage.selectCreditCardOption()
        addMoneyPage.selectCurrency(currency: "USD")
        XCTAssertTrue(addMoneyFromCrediCardPage.getAmount() == "00.00")
        addMoneyFromCrediCardPage.enterAmount(amount: "50")
        addMoneyFromCrediCardPage.enterFirstName(firstName: testData.firstName)
        addMoneyFromCrediCardPage.enterLastName(lastName: testData.lastName)
        addMoneyFromCrediCardPage.enterAddress(address: testData.street)
        addMoneyFromCrediCardPage.enterCity(city: testData.city)
        addMoneyFromCrediCardPage.enterZip(zip: testData.zipCode)
        addMoneyFromCrediCardPage.enterCounty(country: testData.country)
        addMoneyFromCrediCardPage.enterPhoneCode(code: "+123")
        addMoneyFromCrediCardPage.enterPhone(phone: "1")
        addMoneyFromCrediCardPage.tapDone()
        XCTAssertTrue(Page.app.staticTexts["Invalid phone number"].exists) // Fails because of LMW-508
    }
    
    func testBuyAsset() {
        // Buy asset

        let buyPage = BuyPage()
        let transactionsPage = TransactionsPage()
        
        buyPage.open()
        buyPage.selectBuyAsset(asset: "USD")
        buyPage.tapDoneBtn()
        
        buyPage.selectPayWithAsset(asset: "EUR")
        buyPage.tapDoneBtn()
        
        buyPage.enterBuyAmount(amount: "11.12")
        buyPage.tapNextBtn()
        
        buyPage.tapDoneBtn()
        
        buyPage.tapBuyBtn()

        XCTAssertTrue(Page.app.staticTexts["Your exchange has been successfuly processed.It will appear in your transaction history soon."].exists)
        
        transactionsPage.open()
        Page.app.staticTexts["TRANSACTIONS"].waitForExistence(timeout: 10) //TODO: make helper method
        
        XCTAssertTrue(Page.app.staticTexts["Buy USD"].exists && Page.app.staticTexts["+11.12 USD"].exists)
    }
    
    func testSellAsset() {
        // Sell asset
        
        let sellPage = SellPage()
        let transactionsPage = TransactionsPage()
        
        sellPage.open()
        sellPage.selectSellAsset(asset: "USD")
        sellPage.tapDoneBtn()
        
        sellPage.selectReceiveAsset(asset: "EUR")
        sellPage.tapDoneBtn()
        
        sellPage.enterSellAmount(amount: "10.01")
        sellPage.tapNextBtn()
        
        sellPage.tapDoneBtn()
        
        sellPage.tapSellBtn()
        
        XCTAssertTrue(Page.app.staticTexts["Your exchange has been successfuly processed.It will appear in your transaction history soon."].exists)
        
        transactionsPage.open()
        Page.app.staticTexts["TRANSACTIONS"].waitForExistence(timeout: 10) //TODO: make helper method
        
        XCTAssertTrue(Page.app.staticTexts["Sell USD"].exists && Page.app.staticTexts["10.01 USD"].exists)
    }
}

