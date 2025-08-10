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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("No se pudo obtener AppDelegate")
        }
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
            NotificationCenter.default.post(name: .contactsDidUpdate, object: nil)
        } catch {
            print("Error fetching contacts: \(error)")
            contacts = []
        }
    }
    
    func addContact(firstName: String, lastName: String, phoneNumber: String, imageUrl: String? = "") async {

        let newContact = ContactsDataEntity(context: context)
        newContact.id = UUID()
        newContact.firstName = firstName
        newContact.lastName = lastName
        newContact.phoneNumber = phoneNumber
        if let image = await saveImage(imageUrl: imageUrl ?? "") {
            newContact.imageUrl = image
        }
        
        saveContext()
        fetchContacts()
    }
    
    @objc func deleteContact(_ id: UUID) {
        if let contactToDelete = contacts.first(where: { $0.id == id }) {
            context.delete(contactToDelete)
            saveContext()
            fetchContacts()
        }
    }
    
    func updateContact(contact: ContactsDataEntity, firstName: String, lastName: String, phoneNumber: String, imageUrl: String? = "") async {

        contact.firstName = firstName
        contact.lastName = lastName
        contact.phoneNumber = phoneNumber
        if let image = await saveImage(imageUrl: imageUrl ?? "") {
            contact.imageUrl = image
        }

        saveContext()
        fetchContacts()
    }
    
    func saveImage(imageUrl: String = "") async -> String? {
        if imageUrl.isEmpty == true {
            let newImageUrl = await getImageUrl()
            return newImageUrl ?? ""
        }
        
        return imageUrl
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func validatePhoneNumber(phoneNumber: String) -> Bool {
        guard let _ = Int(phoneNumber) else {
            return false
        }
        return true
    }
    
    func getImageUrl() async -> String? {
        guard let url = URL(string: "https://picsum.photos/600/600") else {
            return nil
        }
        do {
            let ( _, response ) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse {
                return httpResponse.url?.absoluteString
            }
            return nil
        } catch {
            print("Error fetching image URL: \(error)")
            return nil
        }
    }

}

extension Notification.Name {
    static let contactsDidUpdate = Notification.Name("contactsDidUpdate")
}
