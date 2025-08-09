//
//  AddContactViewWrapper.swift
//  My Contacts
//
//  Created by Cosme Stakemann on 9/8/25.
//

import SwiftUI

@MainActor
@objc class AddContactViewWrapper: NSObject {
    private let viewModel = ContactViewModel.shared
    @objc func makeViewController() -> UIViewController {
        let view = AddContactView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }
    
    @objc func getContacts() -> [ContactsDataEntity] {
        return viewModel.contacts
    }
}
