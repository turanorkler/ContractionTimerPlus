//
//  MainView.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var lm = LanguageManager.shared
    @StateObject private var storeManager = StoreManager.shared
    @StateObject private var viewModel = MainViewModel()
    //@StateObject private var contactViewModel: ContactsViewModel
    @Environment(\.modelContext) private var modelContext
    
    @ObservedObject var constants = Constants.shared
    
    @State private var firstRun = false
    @State private var showDeleteAlert = false
    @State private var showRestoreAlert = false
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack
        {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0)
            {
                VStack(spacing: 0) {
                    Spacer()
                    HStack {
                        Button(action: { dismiss() })
                        {
                            Image(systemName: "chevron.backward")
                                .resizable()
                                .frame(width:10, height: 15)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        
                        Text("Settings")
                            .font(.custom("Poppins-Medium", size: 20))
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity, maxHeight: 95)
                .background(.headerbg)
                
                
                //içerik buradan devam edecek...
                if storeManager.isSubscriptionActive == false {
                    HStack {
                        
                        VStack(alignment: .leading, spacing: 13) {
                            Text("Unlock all the features".localized)
                                .font(.custom("Poppins-Medium", size: 14))
                                .foregroundColor(.black)
                            
                            Text("Contraction \nTimer Plus +")
                                .font(.custom("DMSerifDisplay-Regular", size: 22))
                                .foregroundColor(.black)
                            
                            Button(action: {
                                constants.fullScreenCover = .paywall2
                            }) {
                                HStack {
                                    Image(systemName: "lock")
                                        .foregroundColor(.white)
                                    
                                    Text("Unlock".localized)
                                        .font(.custom("Poppins-Medium", size: 15))
                                        .foregroundColor(.white)
                                    
                                }
                                .padding(10)
                                .background(Color.greenradial1)
                                .cornerRadius(10)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        Spacer() // Sağ tarafı boş bırak
                        
                        Image("settingspregnant")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 170) // Sabit yükseklik kullan
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading) // HStack de sola yaslansın
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(20)
                    .padding(20)
                }
                
                VStack(spacing: 15)
                {
                    /*
                    Toggle("Show useful tips", isOn: $constants.showUseFullTips)
                        .font(.custom("Poppins-Medium", size: 15))
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                        .background(Color.headerbg)
                        .cornerRadius(10)
                    */
                    
                    Toggle("Ask_intensity_of_contractions".localized, isOn: $constants.contractionIntensity)
                        .font(.custom("Poppins-Medium", size: 15))
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                        .background(Color.headerbg)
                        .cornerRadius(10)
                    
                    NavigationLink(destination: ContactView())
                    {
                        SettingsButton(title: "Contact_List".localized)
                    }
                    .foregroundColor(.black)
                    
                    Button(action: {
                        Task {
                            await storeManager.checkSubscriptionStatus()
                            self.showRestoreAlert = true
                        }
                    })
                    {
                        SettingsButton(title: "Restore_purchases".localized)
                    }
                    
                    Button(action : {
                        lm.showLanguageSheet = true
                    }) {
                        SettingsButton(title: "Language_Change".localized)
                    }
                    
                    SettingsButton(title: "Support")
                    
                    Button(action : {
                        showDeleteAlert = true
                    }) {
                        HStack {
                            Image(systemName: "trash")
                                .foregroundColor(.alarmred)
                            Text("Delete all contractions")
                                .font(.custom("Poppins-Medium", size: 15))
                                .foregroundColor(.alarmred)
                            
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.alarmred.opacity(0.2))
                        .cornerRadius(10)
                    }
                    
                }
                .padding(.top, 5)
                .padding(.horizontal, 20)
            }
            //.padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $lm.showLanguageSheet) {
            LanguageSelectionView()
                //.presentationDetents([.medium])
                .presentationDetents([.fraction(0.42)])
        }
        .alert("Are you sure all Records will be deleted?".localized, isPresented: $showDeleteAlert) {
            Button("Cancel".localized, role: .cancel) {
                showDeleteAlert = false
            } // Kullanıcı iptal edebilir
            Button("Remove All".localized, role: .destructive) {
                //bu kişileri değil sadece maindeki veri girişlerini silecek...
                viewModel.deleteAllProcesses(modelContext: modelContext)
                showDeleteAlert = false
            }
        }
        .alert(isPresented: $showRestoreAlert) {
            Alert(title: Text("Subscription Control".localized),
                  message:
                    Text(storeManager.isSubscriptionActive ? "Subscription is active!".localized : "Subscription no".localized),
                  dismissButton: .default(Text("Ok".localized)))
        }
    }
}

#Preview {
    SettingsView()
}
