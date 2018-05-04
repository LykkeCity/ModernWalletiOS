class CreatePINPage: Page {
    
    func enterDigit(digit: String) {
        Page.app.buttons[digit].tap()
    }
    
    func enterPIN(pin: String) {
        let pin = pin
        
        for digit in pin {
            enterDigit(digit: "\(digit)")
        }
    }
    
    func confirmPIN(pin: String) {
        enterPIN(pin: pin)
    }
}
