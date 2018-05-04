class RegistrationEnterEmailValidationCodePage: Page {
    
    let typeCodeField = Page.app.textFields["Code"]
    let confirmButton = Page.app.buttons["CONFIRM"]
    
    func tapConfirmButton() {
        confirmButton.tap()
    }
    
    func tapCodeField() {
        typeCodeField.tap()
    }
    
    func enterCode(code: String) {
        typeCodeField.typeText(code)
    }
}
