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
class CoreDataDatasource: ContactProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("No se pudo obtener AppDelegate")
        }
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func fetchContacts() throws -> [ContactsDataEntity] {
        let request: NSFetchRequest<ContactsDataEntity> = ContactsDataEntity.fetchRequest()
        return try context.fetch(request)
    }
    
    func addContact(firstName: String, lastName: String, phoneNumber: String, imageUrl: String?) async {
        
    }
    
    func deleteContact(_ id: UUID) {
        
    }
    
    func updateContact(contact: ContactsDataEntity, firstName: String, lastName: String, phoneNumber: String, imageUrl: String?) async {
        
    }
}
