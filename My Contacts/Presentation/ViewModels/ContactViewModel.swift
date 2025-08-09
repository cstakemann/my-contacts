//
//  ContactViewModel.swift
//  My Contacts
//
//  Created by Cosme Stakemann on 9/8/25.
//

import Foundation
import CoreData
import UIKit

@MainActor
@objc class ContactViewModel: NSObject, ObservableObject {
    @objc static let shared = ContactViewModel()
    @Published var contacts: [ContactsDataEntity] = []
    
    private let context: NSManagedObjectContext
    
    override init() {
        // Usamos el contexto principal de Core Data (app delegate)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("No se pudo obtener AppDelegate")
        }
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        
        super.init()
        
        fetchContacts()
    }
    
    @objc func getContacts() -> NSArray {
        return contacts as NSArray
    }
    
    func fetchContacts() {
        let request: NSFetchRequest<ContactsDataEntity> = ContactsDataEntity.fetchRequest()
        
        do {
            contacts = try context.fetch(request)
            print("Fetched contacts count: \(contacts.count)");
            NotificationCenter.default.post(name: .contactsDidUpdate, object: nil)
        } catch {
            print("Error fetching contacts: \(error)")
            contacts = []
        }
    }
    
    func addContact(firstName: String, lastName: String, phoneNumber: String) {
        let newContact = ContactsDataEntity(context: context)
        newContact.firstName = firstName
        newContact.lastName = lastName
        newContact.phoneNumber = phoneNumber
        
        saveContext()
        fetchContacts()
    }
    
    @objc func deleteContact(_ index: Int) {
        guard index < contacts.count else { return }
        let contactToDelete = contacts[index]
        context.delete(contactToDelete)
        saveContext()
        fetchContacts()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

extension Notification.Name {
    static let contactsDidUpdate = Notification.Name("contactsDidUpdate")
}
