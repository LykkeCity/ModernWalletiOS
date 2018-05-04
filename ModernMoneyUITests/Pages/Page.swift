import XCTest

class Page {
    static let app = XCUIApplication()
    var elementsQuery = app.scrollViews.otherElements
    let errorAlert = app.alerts["Error"]
    
    private func waitForPageLoad() {}
    
    required init() {
        waitForPageLoad()
    }
    
    func isErrorAlert(alertText: String) -> Bool {
        let exist = errorAlert.staticTexts[alertText].exists
        return exist
    }
    
    func closeErrorAlert() {
        errorAlert.buttons["OK"].tap()
    }

}
