//
//  ContactDetailView.swift
//  My Contacts
//
//  Created by Cosme Stakemann on 9/8/25.
//

import SwiftUI
import Kingfisher

struct ContactDetailView: View {
    @ObservedObject var viewModel: ContactViewModel
    let contact: ContactsDataEntity
    @State private var isEditing = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                CardImage(imageUrl: contact.imageUrl ?? "")
                    .padding(.top, 20)

                Form {
                    Section(header: Text("Name")) {
                        Text(contact.firstName ?? "")
                            .font(.subheadline)
                        Text(contact.lastName ?? "")
                            .font(.subheadline)
                    }
                    .listRowBackground(Color.gray.opacity(0.3))
                    
                    Section(header: Text("Phone")) {
                        Button(action: {
                            if let phone = contact.phoneNumber, let url = URL(string: "tel://\(phone)") {
                                if UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }) {
                            Text(contact.phoneNumber ?? "No phone")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                    .listRowBackground(Color.gray.opacity(0.3))
                }
                .scrollContentBackground(.hidden)
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.1))
            .navigationTitle("Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        isEditing = true
                    }
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            EditContactView(viewModel: viewModel, contact: contact, onSave: {
                isEditing = false
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
}
