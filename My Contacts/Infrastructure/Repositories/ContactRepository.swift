//
//  ContactRepository.swift
//  My Contacts
//
//  Created by Cosme Stakemann on 10/8/25.
//

import Foundation

class ContactRepository: ContactProtocol {
    let dataSource: ContactProtocol
    
    init(dataSource: ContactProtocol) {
        self.dataSource = dataSource
    }
    
    func fetchContacts() throws -> [ContactsDataEntity] {
        return try dataSource.fetchContacts()
    }
    
    func addContact(firstName: String, lastName: String, phoneNumber: String, imageUrl: String?) async {
        
    }
    
    func deleteContact(_ id: UUID) {
        
    }
    
    func updateContact(contact: ContactsDataEntity, firstName: String, lastName: String, phoneNumber: String, imageUrl: String?) async {
        
    }
    
}
