//
//  ContactProtocol.swift
//  My Contacts
//
//  Created by Cosme Stakemann on 10/8/25.
//
import UIKit
import Foundation

@MainActor
@objc protocol ContactProtocol {
    func fetchContacts() throws -> [ContactsDataEntity]
    func addContact(firstName: String, lastName: String, phoneNumber: String, imageUrl: String?) throws
    @objc func deleteContact(contact: ContactsDataEntity) throws
    func updateContact(contact: ContactsDataEntity, firstName: String, lastName: String, phoneNumber: String, imageUrl: String?) throws
}
