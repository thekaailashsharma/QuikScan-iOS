//
//  ContactsView.swift
//  QuikScan
//
//  Created by Kailash on 30/03/24.
//

import SwiftUI
import Contacts

struct ContactsView: View {
    @Binding var vCard: VCard
    @Binding var isVCardVisible: Bool
    @EnvironmentObject var cameraViewModel: CameraViewModel
    let contact = CNMutableContact()
    let store = CNContactStore()
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DefaultTextField(text: $vCard.jobTitle, keyboardType: .default, label: "Title") {
                        
                    }
                    
                } header: {
                    Text("Title")
                        .font(.customFont(.poppins, size: 15))
                        .padding()
                }
                
                Section {
                    DefaultTextField(text: $vCard.firstName, keyboardType: .default, label: "First Name") {
                        
                    }
                    DefaultTextField(text: $vCard.lastName, keyboardType: .default, label: "Last Name") {
                        
                    }
                    
                } header: {
                    Text("Personal Information")
                        .font(.customFont(.poppins, size: 15))
                        .padding()
                }
                
                Section {
                    if vCard.phoneNumbers.count > 0 {
                        
                        DefaultTextField(text: $vCard.phoneNumbers.first ?? .constant(""), keyboardType: .numberPad, label: "Phone Number") {
                            
                        }
                        
                    }
                    
                } header: {
                    Text("Phone Number")
                        .font(.customFont(.poppins, size: 15))
                        .padding()
                }
                
                Section {
                    if vCard.emails.count > 0 {
                        
                        DefaultTextField(text: $vCard.emails.first ?? .constant(""), keyboardType: .emailAddress, label: "Email Address") {
                            
                        }
                        
                    }
                    
                } header: {
                    Text("Email Address")
                        .font(.customFont(.poppins, size: 15))
                        .padding()
                }
                
                Section {
                    DefaultTextField(text: $vCard.organization, keyboardType: .default, label: "Organization") {
                        
                    }
                } header: {
                    Text("Organization")
                        .font(.customFont(.poppins, size: 15))
                        .padding()
                }
            }
            .navigationTitle("New Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isVCardVisible = false
                    } label: {
                        Text("Cancel")
                    }

                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        contact.namePrefix = vCard.firstName
                        contact.nameSuffix = vCard.lastName
                        contact.emailAddresses = cameraViewModel.convertEmailToCNLabeledValue(vCard.emails)
                        contact.phoneNumbers = cameraViewModel.convertPhoneToCNPhoneNumbers(vCard.phoneNumbers)
                        contact.jobTitle = vCard.jobTitle
                        contact.organizationName = vCard.organization
                        let saveRequest = CNSaveRequest()
                        saveRequest.add(contact, toContainerWithIdentifier: nil)
                        do {
                            try store.execute(saveRequest)
                        } catch {
                            print(error)
                        }
                        isVCardVisible = false
                    } label: {
                        Text("Save")
                    }

                }
            }
            
            
        }
    }
}

struct DefaultTextField: View {
    @Binding var text: String
    var keyboardType: UIKeyboardType
    var label: String
    var onClick: () -> Void
    
    var body: some View {
        TextField(text: $text, label: {
            Text(label)
                .font(.customFont(.poppins, size: 15))
                .padding()
        })
        .submitLabel(.continue)
        .keyboardType(keyboardType)
        .font(.customFont(.poppins, size: 14))
        .foregroundStyle(.white)
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.5))
        }
    }
}
