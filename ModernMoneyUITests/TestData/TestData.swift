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
    var street: String { get }
    var city: String { get }
    var zipCode: String { get }
    var country: String { get }
}

class TestData: TestDataProtocol {
    let faker = Faker(locale: "nb-NO")
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String
    let password: String
    let hunt: String
    let street: String
    let city: String
    let zipCode: String
    let country: String
    
    init() {
        firstName = faker.name.firstName()
        lastName = faker.name.lastName()
        email = faker.internet.email()
        phoneNumber = "+359" + faker.phoneNumber.phoneNumber() //TODO: Generate the code
        password = faker.internet.password()
        hunt = faker.lorem.word()
        street = faker.address.streetName() + " " + faker.address.streetSuffix()
        city = faker.address.city()
        zipCode = faker.address.postcode()
        country = faker.address.country()
    }
}
