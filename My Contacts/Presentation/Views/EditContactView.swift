//
//  EditContactView.swift
//  My Contacts
//
//  Created by Cosme Stakemann on 9/8/25.
//

import SwiftUI

struct EditContactView: View {
    @ObservedObject var viewModel: ContactViewModel
    @State var firstName: String
    @State var lastName: String
    @State var phoneNumber: String
    @State var imageUrl: String
    @State private var isValidNumber: Bool = true
    @State private var isLoading: Bool = false
    
    let contact: ContactsDataEntity
    var onSave: (() -> Void)?
    
    @Environment(\.presentationMode) var presentationMode

    init(viewModel: ContactViewModel, contact: ContactsDataEntity, onSave: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.contact = contact
        self.onSave = onSave
        
        _firstName = State(initialValue: contact.firstName ?? "")
        _lastName = State(initialValue: contact.lastName ?? "")
        _phoneNumber = State(initialValue: contact.phoneNumber ?? "")
        _imageUrl = State(initialValue: contact.imageUrl ?? "")
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                CardImage(imageUrl: contact.imageUrl ?? "")
                    .padding(.top, 20)
                
                Form {
                    Section(header: Text("Name")) {
                        TextField("First Name", text: $firstName)
                        TextField("Last Name", text: $lastName)
                    }
                    
                    Section(header: Text("Phone")) {
                        TextField("Phone Number", text: $phoneNumber)
                            .keyboardType(.phonePad)
                        
                        if !isValidNumber {
                            Text("Phone number just accepts digits.")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .background(Color.gray.opacity(0.1))
            .navigationTitle("Edit Contact")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: trailingView()
            )
        }
    }
    
    @ViewBuilder
    func trailingView() -> some View {
        if isLoading {
            ProgressView()
        } else {
            Button("Save") {
                isValidNumber = true
                isLoading = true
                if !viewModel.validatePhoneNumber(phoneNumber: phoneNumber) {
                    isValidNumber = false
                    isLoading = false
                    return
                }
                Task {
                    await viewModel.updateContact(contact: contact, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, imageUrl: imageUrl)
                    presentationMode.wrappedValue.dismiss()
                    isLoading = false
                    onSave?()
                }

            }
            .disabled(firstName.isEmpty || lastName.isEmpty || phoneNumber.isEmpty)
        }
    }
}
