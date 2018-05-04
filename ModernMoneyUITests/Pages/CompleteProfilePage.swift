class CompleteProfilePage: Page {
    
    let firstNameTextField = Page.app.textFields["First name"]
    let lastNameTextField = Page.app.textFields["Last name"]
    let nextButton = Page.app.buttons["NEXT"]
    
    func tapFirstNameTextField() {
        firstNameTextField.tap()
    }
    
    func tapLastNameTextField() {
        lastNameTextField.tap()
    }
    
    func enterFirstName(firstName: String) {
        firstNameTextField.typeText(firstName)
    }
    
    func enterLastName(lastName: String) {
        lastNameTextField.typeText(lastName)
    }
    
    func tapNextButton() {
        nextButton.tap()
    }
}
