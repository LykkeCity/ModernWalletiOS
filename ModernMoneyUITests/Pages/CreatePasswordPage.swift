class CreatePasswordPage: Page {
    
    let enterAPasswordSecureTextField = Page.app.secureTextFields["Enter a password"]
    let enterAgainSecureTextField = Page.app.secureTextFields["Enter again"]
    let nextButton = Page.app.buttons["NEXT"]
    
    func tapEnterAPasswordSecureTextField() {
        enterAPasswordSecureTextField.tap()
    }
    
    func tapEnterAgainSecureTextField() {
        enterAgainSecureTextField.tap()
    }
    
    func enterPassword(password: String) {
        enterAPasswordSecureTextField.typeText(password)
    }
    
    func enterPasswordAgain(password: String) {
        enterAgainSecureTextField.typeText(password)
    }
   
    func tapNextButton() {
        nextButton.tap()
    }
}
