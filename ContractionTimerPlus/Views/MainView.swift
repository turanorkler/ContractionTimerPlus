//
//  MainView.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//

import SwiftUI
import GoogleMobileAds

struct MainView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var viewModel = MainViewModel()
    @ObservedObject var constants = Constants.shared
    @StateObject private var apple = AuthViewModel.shared
    @StateObject private var storeManager = StoreManager.shared
    @State private var firstRun = false

    var body: some View {
        ZStack
        {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0)
            {
                VStack(spacing: 0) {
                    Spacer()
                    HStack {
                        NavigationLink(destination: SettingsView())
                        {
                            Image(systemName: "gearshape")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        
                        Text("Contractions".localized)
                            .font(.custom("Poppins-Medium", size: 20))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button(action : {
                            constants.popUpCover = .gotoHospital
                        }) {
                            Image(systemName: "crown")
                                .resizable()
                                .frame(width: 30, height: 25)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity, maxHeight: 95)
                .background(.headerbg)
                
                /*
                VStack {
                    Text("👤 Ad Soyad: \(apple.fullName)")
                    Text("📧 E-posta: \(apple.email)")
                    Text("🔑 UID: \(apple.user?.uid ?? "Yok")")
                    
                    Button(action: {
                        apple.signOut()
                    }) {
                        Text("Çıkış Yap")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(.black)
                */
                if viewModel.screen == .start {
                    StartView()
                        .environmentObject(viewModel)
                } else if viewModel.screen == .home {
                    HomeView()
                        .environmentObject(viewModel)
                }
                //.background(.secondary)
                if constants.isPay == false {
                    HStack {
                        
                        BannerView(adUnitID: "ca-app-pub-3940256099942544/2934735716")
                                        .frame(width: 320, height: 50)
                                        .padding(20)
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
        .environmentObject(viewModel)
        .onAppear {
            if !firstRun {
                firstRun = false
                if storeManager.isSubscriptionActive == false {
                    constants.fullScreenCover = .paywall1
                }
            }
            
            viewModel.loadPaingList(modelContext: modelContext)
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainView()
}
