//
//  ContentView.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 19.02.2025.
//

import SwiftUI

struct OnboardingView2: View {
    var body: some View {
        ZStack {
            // Arka Plan
            Color.splashcolor2 // Arka plan rengi
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 0) {
                // Üstteki İçerik
                Image("onboarding2")
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                VStack(alignment: .center, spacing: -15) {
                    Text("Lots_of_features_along".localized)
                        .multilineTextAlignment(.center)
                        .padding(.all, 0)
                }
                .frame(maxWidth: .infinity)
                .font(.custom("DMSerifDisplay-Regular", size: 30))
                .foregroundColor(.black)
                
                
                Text("Contraction_timer_is_not_just".localized)
                    .multilineTextAlignment(.center)
                    .font(.custom("Poppins-Medium", size: 16))
                    .foregroundColor(.black)
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                    .lineLimit(nil)
                
                Spacer()
                
                NavigationLink(destination: MainView()) {
                    Text("Next".localized)
                        .font(.custom("Poppins-Medium", size: 18))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    )
                }
                .padding(.horizontal, 20)
                //.padding(.bottom, 15)
                .safeAreaPadding(.bottom)
                
            }
            .padding(.top, 40)
        }
        .navigationBarBackButtonHidden(true)
    }

}

#Preview {
    OnboardingView()
}

#Preview {
    OnboardingView2()
}
