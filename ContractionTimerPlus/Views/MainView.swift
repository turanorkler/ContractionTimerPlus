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
    
    @AppStorage("appFirstRun") private var appFirstRun: Bool = false
    @StateObject private var viewModel = MainViewModel()
    @ObservedObject var constants = Constants.shared
    @ObservedObject var apple = AuthViewModel.shared
    @ObservedObject var storeManager = StoreManager.shared
    @State private var firstRun = false
    @State private var hasCheckedSubscription = false
    
    var body: some View {
        ZStack
        {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0)
            {
                VStack(spacing: 0)
                {
                    HStack(alignment: .bottom)
                    {
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
                        
                        if storeManager.isSubscriptionActive {
                            Image(systemName: "crown")
                                .resizable()
                                .frame(width: 30, height: 25)
                                .foregroundColor(.black)
                            
                        } else {
                            
                            Button(action: {
                                constants.fullScreenCover = .paywall2
                            }) {
                                HStack(alignment: .bottom)
                                {
                                    Text("No_Ads".localized)
                                        .font(.custom("Poppins-Medium", size: 12))
                                        .padding(8)
                                        .background(.greenradial)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .frame(height: 40)
                                }
                            }
                            
                            
                        }
                    }
                    .padding(.top, 50)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
                
                .frame(maxWidth: .infinity)
                .background(.headerbg)
                
                if !appFirstRun {
                    if viewModel.screen == .start {
                        StartView()
                            .environmentObject(viewModel)
                    } else if viewModel.screen == .home {
                        HomeView()
                            .environmentObject(viewModel)
                    }
                } else {
                    HomeView()
                        .environmentObject(viewModel)
                }
                
                //.background(.secondary)
                if storeManager.isSubscriptionActive == false {
                    HStack {
                        
                        BannerView()
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
        .environmentObject(viewModel)
        .onAppear {
            
            if !hasCheckedSubscription {
                hasCheckedSubscription = true
                if storeManager.isSubscriptionActive == false {
                    constants.fullScreenCover = .paywall1
                    
                    viewModel.loadPaingList(modelContext: modelContext)

                }
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainView()
}
