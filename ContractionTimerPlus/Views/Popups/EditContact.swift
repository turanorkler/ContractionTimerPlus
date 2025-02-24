//
//  PopUp.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 22.02.2025.
//

import SwiftUI
import SwiftData

struct EditContact: View {
    
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var constants = Constants.shared
    @ObservedObject var viewModel: ContactsViewModel // ViewModel

    @State private var contactNo: Int = 0
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var isContact: Bool = false
    @State private var isUrgent: Bool = false
    @State private var color: Color = Color.random()

    var body: some View {
        ZStack {
            Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                VStack(alignment: .leading) {
                    HStack {
                        Button(action : {
                            constants.popUpCover = nil
                            viewModel.clearSelection() // Seçili Kişiyi Temizle
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }

                    // 📌 Başlık ve İkon
                    Image(systemName: "person.badge.plus")
                        .resizable()
                        .frame(width: 50, height:50)
                        .foregroundColor(.greenradial)
                        .padding(.top, 20)

                    Text(contactNo == 0 ? "Add Contact" : "Edit Contact")
                        .font(.custom("Poppins-Medium", size: 25))
                        .foregroundColor(.black)

                    // **FORM ALANI**
                    Text("Name *")
                        .font(.custom("Poppins-Medium", size: 13))
                        .foregroundColor(.black)

                    TextField("Name", text: $name)
                        .font(.custom("Poppins-Medium", size: 16))
                        .padding(10)
                        .cornerRadius(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(.black, lineWidth: 1)
                        }

                    Text("E-mail")
                        .font(.custom("Poppins-Medium", size: 13))
                        .foregroundColor(.black)

                    TextField("E-mail", text: $email)
                        .font(.custom("Poppins-Medium", size: 16))
                        .padding(10)
                        .cornerRadius(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(.black, lineWidth: 1)
                        }
                        .keyboardType(.emailAddress)

                    Text("Phone")
                        .font(.custom("Poppins-Medium", size: 13))
                        .foregroundColor(.black)

                    TextField("Phone", text: $phone)
                        .font(.custom("Poppins-Medium", size: 16))
                        .padding(10)
                        .cornerRadius(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(.black, lineWidth: 1)
                        }
                        .keyboardType(.phonePad)

                    Toggle("Report", isOn: $isContact)
                        .font(.custom("Poppins-Medium", size: 13))
                        .foregroundColor(.black)

                    Toggle("Urgent", isOn: $isUrgent)
                        .font(.custom("Poppins-Medium", size: 13))
                        .foregroundColor(.black)
                        .padding(.bottom, 20)

                    // ✅ Ekle / Güncelle Butonu
                    Button(action: {
                        viewModel.addOrUpdateContact(
                            modelContext: modelContext,
                            contactNo: contactNo,
                            name: name,
                            email: email,
                            phone: phone,
                            contact: isContact,
                            urgent: isUrgent
                        )
                        constants.popUpCover = nil
                        viewModel.clearSelection() // Seçili kişi temizlendi
                    }) {
                        Text(contactNo == 0 ? "Add Contact" : "Update Contact")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.greenradial)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(20)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20)
                .onAppear { // **Burada Değerleri Güncelliyoruz**
                    if let contact = viewModel.selectedContact {
                        contactNo = contact.contactNo
                        name = contact.name
                        email = contact.email ?? ""
                        phone = contact.phone ?? ""
                        isContact = contact.contact
                        isUrgent = contact.urgent
                    } else {
                        // Yeni kişi ekleme için alanları temizle
                        contactNo = 0
                        name = ""
                        email = ""
                        phone = ""
                        isContact = false
                        isUrgent = false
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}


/*
struct EditContact: View {
    
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var constants = Constants.shared
    @ObservedObject var viewModel: ContactsViewModel // ViewModel

    @State private var contactNo: Int = 0
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var isContact: Bool = false
    @State private var isUrgent: Bool = false
    @State private var color: Color = Color.random()

    var body: some View {
        ZStack {
            Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                VStack(alignment: .leading)
                {
                    HStack {
                        Button(action : {
                            constants.popUpCover = nil
                            viewModel.clearSelection() // Seçili Kişiyi Temizle
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }

                    // 📌 Başlık ve İkon
                    Image(systemName: "person.badge.plus")
                        .resizable()
                        .frame(width: 50, height:50)
                        .foregroundColor(.greenradial)
                        .padding(.top, 20)

                    Text(viewModel.selectedContact == nil ? "Add Contact" : "Edit Contact")
                        .font(.custom("Poppins-Medium", size: 25))
                        .foregroundColor(.black)

                    // **FORM ALANI**
                    Text("Name *")
                        .font(.custom("Poppins-Medium", size: 13))
                        .foregroundColor(.black)

                    TextField("Name", text: $name)
                        .font(.custom("Poppins-Medium", size: 16))
                        .padding(10)
                        .cornerRadius(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(.black, lineWidth: 1)
                        }

                    Text("E-mail")
                        .font(.custom("Poppins-Medium", size: 13))
                        .foregroundColor(.black)

                    TextField("E-mail", text: $email)
                        .font(.custom("Poppins-Medium", size: 16))
                        .padding(10)
                        .cornerRadius(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(.black, lineWidth: 1)
                        }
                        .keyboardType(.emailAddress)

                    Text("Phone")
                        .font(.custom("Poppins-Medium", size: 13))
                        .foregroundColor(.black)

                    TextField("Phone", text: $phone)
                        .font(.custom("Poppins-Medium", size: 16))
                        .padding(10)
                        .cornerRadius(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(.black, lineWidth: 1)
                        }
                        .keyboardType(.phonePad)

                    Toggle("Report", isOn: $isContact)
                        .font(.custom("Poppins-Medium", size: 13))
                        .foregroundColor(.black)

                    Toggle("Urgent", isOn: $isUrgent)
                        .font(.custom("Poppins-Medium", size: 13))
                        .foregroundColor(.black)
                        .padding(.bottom, 20)

                    // ✅ Ekle / Güncelle Butonu
                    Button(action: {
                        if viewModel.selectedContact == nil {
                            viewModel.addContact(
                                modelContext: modelContext,
                                name: name,
                                email: email,
                                phone: phone,
                                contact: isContact,
                                urgent: isUrgent
                            )
                        } else {
                            viewModel.updateContact(
                                modelContext: modelContext,
                                name: name,
                                email: email,
                                phone: phone,
                                contact: isContact,
                                urgent: isUrgent
                            )
                        }
                        constants.popUpCover = nil
                        viewModel.clearSelection() // Seçili kişi temizlendi
                    }) {
                        Text(viewModel.selectedContact == nil ? "Add Contact" : "Update Contact")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.greenradial)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(20)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20)
                .onAppear { // **Burada Değerleri Güncelliyoruz**
                    if let contact = viewModel.selectedContact {
                        name = contact.name
                        email = contact.email ?? ""
                        phone = contact.phone ?? ""
                        isContact = contact.contact
                        isUrgent = contact.urgent
                    } else {
                        // Yeni kişi ekleme için alanları temizle
                        name = ""
                        email = ""
                        phone = ""
                        isContact = false
                        isUrgent = false
                    }
                }
                

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
*/
#Preview {
    //@Previewable @StateObject var viewModel = ContactsViewModel()
    //EditContact(viewModel: viewModel)
}
