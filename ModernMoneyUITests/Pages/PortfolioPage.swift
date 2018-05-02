class PortfolioPage: Page {
    let viewAllButton = Page.app.tables.buttons["VIEW ALL"]
    let cryptoCurrenciesButton = Page.app.tables.buttons["CRYPTO CURRENCIES"]
    let fiatCurrencies = Page.app.tables.buttons["FIAT CURRENCIES"]
    let addMoneyLink =  Page.app.tables.buttons["+ADD MONEY"]
    let balanceAmount = Page.app.tables/*@START_MENU_TOKEN@*/.staticTexts["balanceAmount"]/*[[".staticTexts[\"$92,618.65\"]",".staticTexts[\"balanceAmount\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    let cryptoCurrencyButton = Page.app.buttons["Crypto filter button"]
    let fiatCurrencyButton = Page.app.buttons["Fiat filter button"]
    let allCurrencyButton = Page.app.buttons["All filter button"]
    let portfolioTable = Page.app.tables["Portfolio table view"]
    

    
    func tapAddMoneyLink() {
        addMoneyLink.tap()
    }
    
    func tapOnCurrency(currency: String) {
        portfolioTable.cells.staticTexts[currency].tap()
    }
    
    func getTotalBalanceAmount() -> String {
        return balanceAmount.label
    }
    
    func showOnlyCryptoCurrencies() {
        cryptoCurrencyButton.tap()
    }
    
    func showOnlyFiatCurrencies() {
        fiatCurrencies.tap()
    }
    
    func showAllCurrrencies() {
        allCurrencyButton.tap()
    }
    
    func swipeTableUp() {
        portfolioTable.swipeUp()
    }
    
    func getTableRowCount() -> Int{
        return portfolioTable.cells.count
    }
}
