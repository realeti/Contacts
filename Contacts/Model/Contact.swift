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

protocol ContactStorageProtocol {
    // Загрузка списка контактов
    func load() -> [ContactProtocol]
    // Сохранение списка контактов
    func save(contacts: [ContactProtocol])
}

struct Contact: ContactProtocol {
    var title: String
    var phone: String
}

class ContactStorage: ContactStorageProtocol {
    // Cсылка на хранилище
    private var storage = UserDefaults.standard
    // ключ, по которому будет происходить сохранение хранилища
    private var storageKey = "contacts"
    
    // Перечисление с ключами для записи в User Defaults
    private enum ContactKey: String {
        case title
        case phone
    }
    
    func load() -> [ContactProtocol] {
        var resultContacts: [ContactProtocol] = []
        let contactsFromStorage = storage.array(forKey: storageKey) as? [[String: String]] ?? []
        
        for contact in contactsFromStorage {
            guard let title = contact[ContactKey.title.rawValue],
                  let phone = contact[ContactKey.phone.rawValue] else {
                continue
            }
            resultContacts.append(Contact(title: title, phone: phone))
        }
        return resultContacts
    }
    
    func save(contacts: [ContactProtocol]) {
        var arrayForStorage: [[String:String]] = []
        
        contacts.forEach { contact in
            var newElementForStorage: Dictionary<String, String> = [:]
            newElementForStorage[ContactKey.title.rawValue] = contact.title
            newElementForStorage[ContactKey.phone.rawValue] = contact.phone
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageKey)
    }
}
