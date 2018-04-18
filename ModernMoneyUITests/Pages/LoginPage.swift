import Foundation
import XCTest

class LoginPage: Page {

    let typeYourEmailTextField = Page.app.textFields["Type your email"]
    let signInButton = Page.app.buttons["SIGN IN"]
    let registerButton = Page.app.buttons["REGISTER"]
    
    func tapYourEmailTextField() {
        typeYourEmailTextField.tap()
    }
    
    func tapSignInButton() {
        signInButton.tap()
    }
    
    func tapRegisterButton() {
        registerButton.tap()
    }
    
    func enterEmail(email: String) {
        typeYourEmailTextField.typeText(email)
    }
} 
