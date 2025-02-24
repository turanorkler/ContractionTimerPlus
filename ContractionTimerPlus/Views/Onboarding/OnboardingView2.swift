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
                    Text("Lots of features along!")
                        .multilineTextAlignment(.center)
                        .padding(.all, 0)
                }
                .frame(maxWidth: .infinity)
                .font(.custom("DMSerifDisplay-Regular", size: 30))
                .foregroundColor(.black)
                
                Text("Contraction timer is not just a regular \ntimer. It is also a tool for recording and \ncommunicating!")
                    .multilineTextAlignment(.center)
                    .font(.custom("Poppins-Medium", size: 16))
                    .foregroundColor(.black)
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                
                Spacer() // İçeriği yukarı itmek için boşluk bırak
                
                // Next Butonu
                NavigationLink(destination: LoginRegisterView()) {
                    Text("Next")
                        .font(.custom("Poppins-Medium", size: 18))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 50) // Buton genişliği ve yüksekliği
                        .background(
                        RoundedRectangle(cornerRadius: 15) // Oval kenarlar
                            .fill(.clear) // Beyaz arka plan
                            .overlay(
                                RoundedRectangle(cornerRadius: 15) // Oval kenarlı border
                                    .stroke(Color.black, lineWidth: 1) // Siyah border
                            )
                    )
                }
                .padding(.horizontal, 20) // Yanlardan boşluk bırak
                .padding(.bottom, 40)
                .safeAreaPadding(.bottom) // Buton genişliği ve yüksekliği
                
            }
            .padding(.top, 40) // İçerik için üst boşluk
        }
        .navigationBarBackButtonHidden(true)
    }

}

#Preview {
    OnboardingView2()
}


/*
ZStack {
    CustomTextView(text: "Welcome to \nContraction \nTimer Plus", lineSpacing: -15)
        .font(.custom("DMSerifDisplay-Regular", size: 55))
        .foregroundColor(.white)
}
*/
