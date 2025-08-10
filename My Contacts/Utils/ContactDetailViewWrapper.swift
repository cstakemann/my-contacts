//
//  ContactDetailViewWrapper.swift
//  My Contacts
//
//  Created by Cosme Stakemann on 9/8/25.
//


import SwiftUI

@MainActor
@objc class ContactDetailViewWrapper: NSObject {
    private let contact: ContactsDataEntity
    private let viewModel = ContactViewModel.shared
    
    @objc init(contact: ContactsDataEntity) {
        self.contact = contact
        super.init()
    }
    
    @objc func makeViewController() -> UIViewController {
        let view = ContactDetailView(viewModel: viewModel, contact: contact)
        return UIHostingController(rootView: view)
    }
}
