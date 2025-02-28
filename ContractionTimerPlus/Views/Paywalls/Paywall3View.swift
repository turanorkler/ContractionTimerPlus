//
//  Paywall1.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//
import SwiftUI

struct Paywall3View : View
{
    @ObservedObject var constants = Constants.shared
    @ObservedObject var storeManager = StoreManager.shared
    
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
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image("gift")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .foregroundColor(.red)
                
                
                Text("we_have_a_special".localized)
                    .font(.custom("DMSerifDisplay-Regular", size: 40))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                Text("gift_for_you".localized)
                    .font(.custom("DMSerifDisplay-Regular", size: 45))
                    .foregroundColor(.lightgreen)
                    .padding(.top, -15)
                
                
                
                PaywallFeatures(color: .white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
                .padding(.horizontal, 15)
                
                
                
                Spacer()
                
                if let product = storeManager.getProductInfo(productID: storeManager.productIDs[3])
                {
                    Text(String(format: NSLocalizedString("premium_weekly".localized, comment: ""),
                                product.priceFormatted))
                    .font(.custom("Poppins-Medium", size: 15))
                    .foregroundColor(.white)
                    
                    CustomButton2(buttonText: "premium_3day_try".localized, action: {
                        Task {
                            try await storeManager.purchase(product)
                        }
                    })
                    .padding(.top, 10)
                }
                
                PrivacyPolicy(color: .white)

            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Paywall3View()
}
