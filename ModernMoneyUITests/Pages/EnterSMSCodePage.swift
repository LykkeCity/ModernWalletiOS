class EnterSMSCodePage: Page {
    
    let codeField = Page.app.textFields["Code"]
    let confirmButton = Page.app.buttons["CONFIRM"]
    
    func tapCodeField() {
        codeField.tap()
    }
    
    func tapConfirnButton() {
        confirmButton.tap()
    }
    
    func enterCode(code: String) {
        codeField.typeText(code)
    }
}
