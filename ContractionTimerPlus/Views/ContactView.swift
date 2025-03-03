//
//  MainView.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//

import SwiftUI
import SwiftData
import Foundation


struct ContactView: View {
    
    @ObservedObject var admob = InterstitialAdManager.shared
    @StateObject private var storeManager = StoreManager.shared
    @Environment(\.modelContext) private var modelContext

    @Environment(\.dismiss) var dismiss
    @ObservedObject var constants = Constants.shared

    @StateObject private var viewModel = ContactsViewModel()
    
    
    var body: some View {
        ZStack {
            
            Color.white.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                headerView()
                
                if viewModel.contactsLists.isEmpty {
                    
                    VStack(alignment: .center)
                    {
                        Image("contactbaby")
                            .resizable()
                            .frame(width: 300, height: 300)
                            .padding()
                        
                        Text("No_contacts_yet".localized)
                            .font(.custom("Poppins-Medium", size: 18))
                            .foregroundColor(.black)
                        
                        Button(action: {
                            viewModel.deleteAllContacts(modelContext: modelContext)
                            viewModel.selectedContact = nil
                            constants.popUpCover = .addContact
                        })
                        {
                            Text(viewModel.selectedContact == nil ? "Add_Contact".localized : "Update_Contact".localized)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.greenradial)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(20)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(20)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 80)
                    
                } else {
                    contactListView()
                }
            }

            .onAppear {
                //let storeURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
                //print("📁 SwiftData DB Konumu: \(storeURL?.path ?? "Bulunamadı!")")
                viewModel.loadContacts(modelContext: modelContext)
                if storeManager.isSubscriptionActive == false {
                    admob.showInterstitialAd()
                }
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .overlay {
                if constants.popUpCover == .addContact {
                    EditContact(viewModel: viewModel)
                }
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
             
    }

    private func headerView() -> some View {
        VStack(spacing: 0) {
            Spacer()
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .frame(width:10, height: 15)
                        .foregroundColor(.black)
                }
                Spacer()
                
                Text("Contacts")
                    .font(.custom("Poppins-Medium", size: 20))
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action : {
                    viewModel.selectedContact = nil
                    constants.popUpCover = .addContact
                }) {
                    Image(systemName: "person.badge.plus")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: 95)
        .background(.headerbg)
    }

    
    private func contactListView() -> some View {
        List(viewModel.contactsLists, id: \.self) { contact in
            ContactRow(contact: contact)
                .swipeActions(edge: .trailing) {
                    
                    Button("Delete", systemImage: "trash")
                    {
                        //modelContext.delete(contact)
                        viewModel.deleteContact(modelContext: modelContext,
                                                contact: contact)
                    }
                    .tint(.alarmred) // Arka plan beyaz
                    .foregroundColor(.alarmred)
                    Button("Update", systemImage: "square.and.pencil") {
                        viewModel.selectedContact = contact
                        constants.popUpCover = .addContact
                    }
                    .tint(.alarmred) // Arka plan beyaz
                    .foregroundColor(.alarmred)
                }
                //.padding(.horizontal, 20)
                //.padding(.vertical, 20)
                .environmentObject(viewModel)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
}

struct ContactRow: View {
    
    @ObservedObject var constants = Constants.shared
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var viewModel: ContactsViewModel
    
    var contact: Contact
    @State private var circleColor: Color = Color.random()
    
    var body: some View {
        HStack {

            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(circleColor)
            
            VStack(alignment: .leading) {
                Text(contact.name)
                    .font(.custom("Poppins-Medium", size: 14))
                    .foregroundColor(.black)
                    
                if let mail = contact.email, !mail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text(String("📧 \(mail)"))
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(.darkgray)
                }

                /*
                if let phone = contact.phone, !phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text(String("📞 \(phone)"))
                        .font(.custom("Poppins-Medium", size: 12))
                }
                 */
            }
            
            Spacer()
            
            Text("Swipe left")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(.greenradial)
                
        }
        .padding(10)
        .listRowSpacing(0)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .background(.headerbg)
        .cornerRadius(10)
    }
}

#Preview {
    ContactView()
}

#Preview {
    ContactRow(contact: Contact(
        contactNo: UUID().hashValue,
        name: "John Doe",
        email: "johndoe@example.com",
        phone: "+1234567890",
        contact: true,
        urgent: false
    ))
}
