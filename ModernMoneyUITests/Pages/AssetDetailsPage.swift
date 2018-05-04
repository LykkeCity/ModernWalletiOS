//
//  AssetDetailsPage.swift
//  ModernMoneyUITests
//
//  Created by Radi Dichev on 2.05.18.
//  Copyright © 2018 Lykkex. All rights reserved.
//

import Foundation

class AssetDetailsPage: Page {
    let sendButton =  Page.app.buttons["Send Button"]
    let receiveButton =  Page.app.buttons["Receive Button"]
    
    func tapSendButton() {
        sendButton.tap()
    }
    
    func tapReceiveButton() {
        receiveButton.tap()
    }
}
