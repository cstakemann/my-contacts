//
//  AddContactView.swift
//  My Contacts
//
//  Created by Cosme Stakemann on 9/8/25.
//



import SwiftUI

struct AddContactView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ContactViewModel
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phoneNumber = ""
    @State private var isValidNumber: Bool = true
    
//    var onSave: (String, String, String) -> Void
    
    var body: some View {
        NavigationView {
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
            .navigationTitle("Add Contact")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    guard let _ = Int(phoneNumber) else {
                        isValidNumber = false
                        return
                    }
                    isValidNumber = true

//                    onSave(firstName, lastName, phoneNumber)
                    viewModel.addContact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(firstName.isEmpty || lastName.isEmpty || phoneNumber.isEmpty)
            )
        }
    }
}
