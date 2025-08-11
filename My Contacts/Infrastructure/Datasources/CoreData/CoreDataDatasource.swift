//
//  CoreDataDatasource.swift
//  My Contacts
//
//  Created by Cosme Stakemann on 10/8/25.
//

import CoreData
import UIKit
import Foundation

@MainActor
@objc class CoreDataDatasource: NSObject, ContactProtocol {
    private let context: NSManagedObjectContext
    
    @objc override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("No se pudo obtener AppDelegate")
        }
        self.context = appDelegate.persistentContainer.viewContext
        
        super.init()
    }
    
    func fetchContacts() throws -> [ContactsDataEntity] {
        let request: NSFetchRequest<ContactsDataEntity> = ContactsDataEntity.fetchRequest()
        return try context.fetch(request)
    }
    
    func addContact(firstName: String, lastName: String, phoneNumber: String, imageUrl: String?) throws {
        let newContact = ContactsDataEntity(context: context)
        newContact.id = UUID()
        newContact.firstName = firstName
        newContact.lastName = lastName
        newContact.phoneNumber = phoneNumber
        newContact.imageUrl = imageUrl
        
        try saveContext()
    }
    
    func deleteContact(contact: ContactsDataEntity) throws {
        context.delete(contact)
        try saveContext()
    }
    
    func updateContact(contact: ContactsDataEntity, firstName: String, lastName: String, phoneNumber: String, imageUrl: String?) throws {
        contact.firstName = firstName
        contact.lastName = lastName
        contact.phoneNumber = phoneNumber
        contact.imageUrl = imageUrl
        
        try saveContext()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
