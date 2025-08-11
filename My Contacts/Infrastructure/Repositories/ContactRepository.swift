//
//  ContactRepository.swift
//  My Contacts
//
//  Created by Cosme Stakemann on 10/8/25.
//

import Foundation


@objc class ContactRepository: NSObject, ContactProtocol {
    let dataSource: ContactProtocol
    
    @objc init(_dataSource: ContactProtocol) {
        self.dataSource = _dataSource
        super.init()
    }
    
    func fetchContacts() throws -> [ContactsDataEntity] {
        return try dataSource.fetchContacts()
    }
    
    func addContact(firstName: String, lastName: String, phoneNumber: String, imageUrl: String?) throws {
        try dataSource.addContact(
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            imageUrl: imageUrl
        )
    }
    
    func deleteContact(contact: ContactsDataEntity) throws {
        try dataSource.deleteContact(contact: contact)
    }
    
    func updateContact(contact: ContactsDataEntity, firstName: String, lastName: String, phoneNumber: String, imageUrl: String?) throws {
        try dataSource.updateContact(
            contact: contact,
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            imageUrl: imageUrl
        )
    }
    
}
