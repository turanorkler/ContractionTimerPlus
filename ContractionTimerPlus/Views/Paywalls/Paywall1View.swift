//
//  Paywall1.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//
import SwiftUI

struct Paywall1View : View
{
    @ObservedObject var constants = Constants.shared
    @ObservedObject var storeManager = StoreManager.shared
    
    var body : some View {
        
        ZStack
        {
            Color.loginregister.edgesIgnoringSafeArea(.all)
            
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
                
                Image("pregnantwoman1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .foregroundColor(.red)
                
                
                Text("Get_Premium_Now".localized)
                    .font(.custom("DMSerifDisplay-Regular", size: 32))
                    .foregroundColor(.black)
                    .padding(0)
                
                
                Text("No_Ads".localized)
                    .padding(10) // 📌 Sadece metnin içinde boşluk bırakır
                    .background(Color.green) // 📌 Arka plan sadece metin ve padding alanını kaplar
                    .cornerRadius(10)
                    .padding(.top, 10)
                
                PaywallFeatures(color: .black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
                .padding(.horizontal, 15)
                
                Spacer()
                
                if let product = storeManager.getProductInfo(productID: storeManager.productIDs[2])
                {
                    Text(String(format: NSLocalizedString("premium_monthly".localized, comment: ""),
                                    product.priceFormatted))
                            .font(.custom("Poppins-Medium", size: 15))
                            .foregroundColor(.black)
                    
                    CustomButton(buttonText: "premium_3day_try".localized, action: {
                        Task {
                            try await storeManager.purchase(product)
                        }
                    })
                    .padding(.top, 10)
                }
                
                PrivacyPolicy(color: .black)

            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
        }
        .onAppear {
           
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Paywall1View()
}
