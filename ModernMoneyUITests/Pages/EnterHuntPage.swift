class EnterHuntPage: Page {
    
    let enterAHintTextField = Page.app.textFields["Enter a hint"]
    let nextButton = Page.app.buttons["NEXT"]
    
    func tapEnterAHuntTextField() {
        enterAHintTextField.tap()
    }
    
    func enterHunt(hunt: String) {
        enterAHintTextField.typeText(hunt)
    }
    func tapNextButton() {
        nextButton.tap()
    }
}
