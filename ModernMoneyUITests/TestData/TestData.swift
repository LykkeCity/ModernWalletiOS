//
//  TestData.swift
//  ModernMoneyUITests
//
//  Created by Radi Dichev on 25.04.18.
//  Copyright © 2018 Lykkex. All rights reserved.
//

import Foundation
import Fakery

protocol TestDataProtocol {
    var faker: Faker {get}
    var firstName: String { get }
    var lastName: String { get }
    var email: String { get }
    var phoneNumber: String { get }
    var password: String { get }
    var hunt: String { get }
}

class TestData: TestDataProtocol {
    let faker = Faker(locale: "nb-NO")
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String
    let password: String
    let hunt: String
    
    
    init() {
        firstName = faker.name.firstName()
        lastName = faker.name.lastName()
        email = faker.internet.email()
        phoneNumber = "+359" + faker.phoneNumber.phoneNumber()
        password = faker.internet.password()
        hunt = faker.lorem.word()
    }
}
