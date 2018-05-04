class RegistrationEmailPage: Page {
    
    let typeYourEmailTextField = Page.app.textFields["Type your email"]
    let confirmButton = Page.app.buttons["CONFIRM"]
    
    func tapYourEmailTextField() {
        typeYourEmailTextField.tap()
    }
    
    func tapConfirmnButton() {
        confirmButton.tap()
    }
    
    func enterEmail(email: String) {
        typeYourEmailTextField.typeText(email)
    }
}
