//
//  MainView.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//

import SwiftUI
import MessageUI

struct SettingsView: View {
    
    var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    var build: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
    
    @ObservedObject var admob = InterstitialAdManager.shared
    @StateObject private var lm = LanguageManager.shared
    @StateObject private var storeManager = StoreManager.shared
    @StateObject private var viewModel = MainViewModel()
    //@StateObject private var contactViewModel: ContactsViewModel
    @Environment(\.modelContext) private var modelContext
    
    @State private var showMailView = false
    @State private var isMailAvailable = MFMailComposeViewController.canSendMail()

    @State private var showAlert : Bool = false
    @State private var errorMessage : String = ""
    
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
                        
                        Text("settings".localized)
                            .font(.custom("Poppins-Medium", size: 20))
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity, maxHeight: 85)
                .background(.headerbg)
                
                
                //içerik buradan devam edecek...
                HStack {
                    
                    VStack(alignment: .leading, spacing: 13) {
                        
                        if storeManager.isSubscriptionActive == false
                        {
                            Text("Unlock_all_the_features".localized)
                                .font(.custom("Poppins-Medium", size: 14))
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.black)
                        }
                        Text("app_name".localized)
                            .font(.custom("DMSerifDisplay-Regular", size: 24))
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(.black)
                        
                        if storeManager.isSubscriptionActive == false
                        {
                            Button(action: {
                                constants.fullScreenCover = .paywall2
                            }) {
                                
                                HStack {
                                    Image(systemName: "lock")
                                        .foregroundColor(.white)
                                    
                                    Text("unlock".localized)
                                        .font(.custom("Poppins-Medium", size: 15))
                                        .foregroundColor(.white)
                                    
                                }
                                .padding(10)
                                .background(Color.greenradial1)
                                .cornerRadius(10)
                            }
                        } else
                        {
                            VStack(alignment: .leading)
                            {
                                Image(systemName: "crown")
                                    .resizable()
                                    .frame(width: 40, height: 30)
                                    .foregroundColor(.black)
                                
                                Text(storeManager.isSubscriptionName.localized)
                                    .font(.custom("Poppins-Medium", size: 15))
                                    .foregroundColor(.black)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                            }
                            .padding(10)
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
                    
                    
                    Toggle("Ask_intensity_of_contractions".localized, isOn: $constants.contractionIntensity)
                        .font(.custom("Poppins-Medium", size: 15))
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                        .background(Color.headerbg)
                        .cornerRadius(10)
                     */
                    
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
                    
                    Button(action: {
                        Task {
                            await storeManager.checkSubscriptionStatus()
                            self.showMailView = true
                        }
                    }) {
                        SettingsButton(title: "Support".localized)
                    }
                    
                    
                    Button(action : {
                        showDeleteAlert = true
                    }) {
                        HStack {
                            Image(systemName: "trash")
                                .foregroundColor(.alarmred)
                            Text("Delete_all_contractions".localized)
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
                
                Spacer()
                
                Text(String("Version \(version) (Build \(build))"))
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                if storeManager.isSubscriptionActive == false {
                    HStack {
                        
                        BannerView(adUnitID: {
                            //#if DEBUG
                                return "ca-app-pub-3940256099942544/2934735716"
                            //#else
                                //return "ca-app-pub-4755969652035514/5821116971"
                            //#endif
                        }())
                        .frame(width: 320, height: 50)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 15)
                        
                        //Text("Reklam buraya gelecek")
                        //    .padding(20)
                    }
                    .frame(maxWidth: .infinity)
                    //.background(.red)
                }
                
                
            }
            //.padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showMailView) {
            //MailView(recipient: "ismail.orkler@gmail.com", subject: "Test Konusu", body: "Bu bir test mailidir.")
            
            MailView(
                recipients: ["ismail.orkler@gmail.com"],
                subject: "Support Mail",
                body: """
                <html>
                <body>
                    <h1>Support Mail</h1>
                    <p></p>
                    <ul>
                        <li><strong>Transaction ID:</strong> \($storeManager.transactionID)</li>
                        <li><strong>Original Transaction ID:</strong> \(storeManager.originalTransactionID)</li>
                    </ul>
                </body>
                </html>
                """,
                attachmentData: nil,
                attachmentMimeType: nil,
                attachmentFileName: nil,
                onError: { error in
                    errorMessage = error.localizedDescription
                    showAlert = true
                }
            )
        }
        .alert("error_title".localized, isPresented: $showAlert) {
            Button(String("Tamam"), role: .cancel) { self.showAlert = false}
        } message: {
            Text(errorMessage) // Kullanıcıya hata mesajını göster
        }
        .sheet(isPresented: $lm.showLanguageSheet) {
            LanguageSelectionView()
                //.presentationDetents([.medium])
                //.presentationDetents([.fraction(0.42)])
                .presentationDetents([.height(490)]) // İçerik boyutuna göre ayarlanabilir
                .presentationDragIndicator(.visible)
        }
        .alert("are_you_deleted".localized, isPresented: $showDeleteAlert) {
            Button("Cancel".localized, role: .cancel) {
                showDeleteAlert = false
            } // Kullanıcı iptal edebilir
            Button("Remove_All".localized, role: .destructive) {
                //bu kişileri değil sadece maindeki veri girişlerini silecek...
                viewModel.deleteAllProcesses(modelContext: modelContext)
                showDeleteAlert = false
            }
        }
        .alert(isPresented: $showRestoreAlert) {
            Alert(title: Text("Subscription_Control".localized),
                  message:
                    Text(storeManager.isSubscriptionActive ?
                         "Subscription_is_active".localized : "Subscription_no".localized),
                  dismissButton: .default(Text("Ok".localized)))
        }
        .onAppear {
            if storeManager.isSubscriptionActive == false {
                admob.showInterstitialAd()
            }
        }
    }
}

#Preview {
    SettingsView()
}
