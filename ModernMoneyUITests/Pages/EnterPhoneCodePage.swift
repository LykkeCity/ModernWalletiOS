class EnterPhoneCodePage: Page {
    
    let codeField = Page.app.textFields["Code"]
    let confirmButton = Page.app.buttons["CONFIRM"]
    
    func tapCodeField() {
        codeField.tap()
    }
    
    func tapConfirmButton() {
        confirmButton.tap()
    }
    
    func enterCode(code: String) {
        codeField.typeText(code)
    }
}
