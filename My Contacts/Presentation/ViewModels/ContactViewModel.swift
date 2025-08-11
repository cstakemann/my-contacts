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
    private let contactRepository: ContactProtocol
    @Published var contacts: [ContactsDataEntity] = []
    
    @objc init(_contactRepository: ContactProtocol) {
        
        self.contactRepository = _contactRepository
        
        super.init()
        
        fetchContacts()
    }
    
    @objc func getContacts() -> NSArray {
        return contacts as NSArray
    }
    
    func fetchContacts() {
        do {
            contacts = try contactRepository.fetchContacts()
            NotificationCenter.default.post(name: .contactsDidUpdate, object: nil)
        } catch {
            print("Error fetching contacts: \(error)")
            contacts = []
        }
    }
    
    func addContact(firstName: String, lastName: String, phoneNumber: String, imageUrl: String? = "") async {
        do {
            let image: String = await saveImage(imageUrl: imageUrl ?? "") ?? ""
            
            try contactRepository.addContact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, imageUrl: image)
            
            fetchContacts()
        } catch {
            print("Error adding contact: \(error)")
        }
    }

    @objc func deleteContact(_ contactToDelete: ContactsDataEntity) {
        do {
            try contactRepository.deleteContact(contact: contactToDelete)
            fetchContacts()
        } catch {
            print("Error delete contact: \(error)")
        }
    }
    
    func updateContact(contact: ContactsDataEntity, firstName: String, lastName: String, phoneNumber: String, imageUrl: String? = "") async {
        
        do {
            let image: String = await saveImage(imageUrl: imageUrl ?? "") ?? ""
            
            try contactRepository.updateContact(contact: contact, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, imageUrl: image)
            
            fetchContacts()
        } catch {
            print("Error update contact: \(error)")
        }
        
    }
    
    func saveImage(imageUrl: String = "") async -> String? {
        if imageUrl.isEmpty == true {
            let newImageUrl = await getImageUrl()
            return newImageUrl ?? ""
        }
        
        return imageUrl
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
