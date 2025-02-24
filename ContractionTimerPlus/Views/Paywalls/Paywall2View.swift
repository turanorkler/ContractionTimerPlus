//
//  Paywall1.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//
import SwiftUI

struct Paywall2View : View
{
    @ObservedObject var constants = Constants.shared
    
    @State private var selectedSub: SubscriptionEnum = .monthly
    
    var body : some View {
        
        ZStack
        {
            Color.splashcolor1.edgesIgnoringSafeArea(.all)
            
            RadialCircle(position: CGPoint(x: 50, y: 10), size: 300)
            RadialCircle(position: CGPoint(x: 400, y: 200), size: 300)
            VStack(spacing: 0) {
                
                HStack
                {
                    Button(action: {
                        constants.fullScreenCover = nil
                        constants.fullScreenCover = .paywall3
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image("pregnantwoman2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220)
                    .foregroundColor(.red)
                
                
                Text("Premium Membership".localized)
                    .font(.custom("DMSerifDisplay-Regular", size: 32))
                    .foregroundColor(.white)
                    .padding(0)
                
                PaywallFeatures(color: .white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
                .padding(.horizontal, 15)
                
                HStack(spacing: 15) { // Yan yana butonlar
                    ToggleButton(title: "Monthly", price: "$9.99", isActive: selectedSub == .monthly) {
                        selectedSub = .monthly
                    }
                    ToggleButton(title: "Yearly", price: "$79.99", isActive: selectedSub == .yearly) {
                        selectedSub = .yearly
                    }
                }
                .padding(.top, 10)
                
                Spacer()
                
                Text("Get premium now with only $9.99/monthly")
                    .font(.custom("Poppins-Medium", size: 15))
                    .foregroundColor(.white)
                
                CustomButton2(buttonText: "Next", action: {
                    
                })
                .padding(.top, 10)
                
                PrivacyPolicy(color: .white)

            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Paywall2View()
}
