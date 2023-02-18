//
//  Contact.swift
//  Contacts
//
//  Created by Apple M1 on 18.02.2023.
//

import UIKit

protocol ContactProtocol {
    // Имя
    var title: String { get set }
    // Номер телефона
    var phone: String { get set }
}

struct Contact: ContactProtocol {
    var title: String
    var phone: String
}
