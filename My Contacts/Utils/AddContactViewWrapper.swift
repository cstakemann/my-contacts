//
//  AddContactViewWrapper.swift
//  My Contacts
//
//  Created by Cosme Stakemann on 9/8/25.
//

import SwiftUI

@MainActor
@objc class AddContactViewWrapper: NSObject {
    private let viewModel: ContactViewModel
    
    override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("No AppDelegate found")
        }
        self.viewModel = appDelegate.contactViewModel
        super.init()
    }
    
    @objc func makeViewController() -> UIViewController {
        let view = AddContactView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }
    
    @objc func getContacts() -> [ContactsDataEntity] {
        return viewModel.contacts
    }
}
