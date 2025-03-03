//
//  ContentView.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 19.02.2025.
//

import SwiftUI
import FirebaseAnalytics
import SwiftData

struct OnboardingView: View {
    
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        
        ZStack
        {
            VStack(alignment: .leading)
            {
                Image("onboarding1")
                    .resizable()
                    .scaledToFit()
                    .padding()
                

                VStack(alignment: .leading, spacing: -15) {
                    Text("Welcome_to".localized)
                    Text(String("Contraction"))
                    HStack {
                        Text(String("Timer Plus + "))
                        Image("heart")
                    }
                    .padding(.all,0)
                }
                .padding(.horizontal, 20)
                .font(.custom("DMSerifDisplay-Regular", size: 45))
                .foregroundColor(.white)
                
                

                Text("Useful_application".localized)
                    .font(.custom("Poppins-Medium", size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                /*
                Button(action: {
                    Analytics.logEvent("custom_event", parameters: [
                        "event_name": "button_tapped",
                        "user_id": "12345"
                    ])
                    //fatalError("Crash was triggered")
                })
                {
                    Text("crashlytics test")
                }
                */
                
                NavigationLink(destination: OnboardingView2(), label: {
                    Text("Next".localized)
                        .font(.custom("Poppins-Medium", size: 18))
                        .foregroundColor(.splashcolor1)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.white)
                        .cornerRadius(15)
                })
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
                .safeAreaPadding(.bottom)
                 
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .safeAreaPadding(.all)
        .padding(.top, 40)
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(.splashcolor1)
    
    }
}

#Preview {
    OnboardingView()
}
