class PortfolioPage: Page {
    let viewAllButton = Page.app.tables.buttons["VIEW ALL"]
    let cryptoCurrenciesButton = Page.app.tables.buttons["CRYPTO CURRENCIES"]
    let fiatCurrencies = Page.app.tables.buttons["FIAT CURRENCIES"]
    let addMoneyLink =  Page.app.tables.buttons["+ADD MONEY"]
    
    func tapAddMoneyLink() {
        addMoneyLink.tap()
    }
    
    func tapOnCurrency(currency: String) {
        Page.app.tables.staticTexts[currency].tap()
    }
    
}
