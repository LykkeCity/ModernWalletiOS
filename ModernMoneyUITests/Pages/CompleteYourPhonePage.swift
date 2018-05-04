class CompleteYourPhonePage: Page {
    
    let phoneNumberTextField = Page.app.textFields["Phone number"]
    let submitButton = Page.app.buttons["SUBMIT"]
    
    func tapPhoneNumberTextField() {
        phoneNumberTextField.tap()
    }
    
    func enterPhoneNumber(phoneNumber: String) {
        phoneNumberTextField.typeText(phoneNumber)
    }
   
    func tapSubmitButton() {
        submitButton.tap()
    }
}
