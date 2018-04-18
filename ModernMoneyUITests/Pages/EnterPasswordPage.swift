import Foundation

class EnterPasswordPage: Page {
    
    let typeYourPasswordTextField = Page.app.secureTextFields["Type your password"]
    let signInButton = Page.app.buttons["SIGN IN"]
    
    func tapYourPasswordTextField() {
        typeYourPasswordTextField.tap()
    }
    
    func tapSignInButton() {
        signInButton.tap()
    }
    
    func enterPassword(password: String) {
        typeYourPasswordTextField.typeText(password)
    }
}
