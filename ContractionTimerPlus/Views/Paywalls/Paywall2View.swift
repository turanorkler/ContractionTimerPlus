//
//  Paywall1.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//
import SwiftUI
import StoreKit

struct Paywall2View : View
{
    @ObservedObject var constants = Constants.shared
    @ObservedObject var storeManager = StoreManager.shared
    @State var selectProduct : Product?
    @State private var selectedSub: SubscriptionEnum = .weekly
    @State private var weekly: Product?
    @State private var monthly: Product?
    
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
                
                
                Text("Premium_Membership".localized)
                    .font(.custom("DMSerifDisplay-Regular", size: 32))
                    .foregroundColor(.white)
                    .padding(0)
                
                PaywallFeatures(color: .white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
                .padding(.horizontal, 15)
                
                HStack(spacing: 15) { // Yan yana butonlar
                    
                    ToggleButton(title: "Weekly".localized, price: weekly?.priceFormatted ?? "",
                                                    isActive: selectedSub == .weekly)
                    {
                        selectedSub = .weekly
                    }
                    
                    ToggleButton(title: "Monthly".localized, price: monthly?.priceFormatted ?? "",
                                                    isActive: selectedSub == .monthly)
                    {
                        selectedSub = .monthly
                    }
                }
                .padding(.top, 10)
                
                Spacer()
                
                if selectedSub == .weekly {
                    Text(String(format: NSLocalizedString("premium_weekly".localized, comment: ""),
                                weekly?.priceFormatted ?? ""))
                    .font(.custom("Poppins-Medium", size: 14))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    
                } else {
                    Text(String(format: NSLocalizedString("premium_monthly".localized, comment: ""),
                                monthly?.priceFormatted ?? ""))
                    .font(.custom("Poppins-Medium", size: 14))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                }
                
                CustomButton2(buttonText: "Next", action: {
                    
                    let pID = selectedSub == .weekly ? storeManager.productIDs[0] : storeManager.productIDs[1]
                    
                    if let fetchedProduct = storeManager.products.first(where: { $0.id == pID })
                    {
                        Task {
                            try await storeManager.purchase(fetchedProduct)
                        }
                    }
                    
                })
                .padding(.top, 10)
                
                PrivacyPolicy(color: .white)

            }
            .onAppear {
                
                self.weekly = storeManager.getProductInfo(productID: storeManager.productIDs[0])
                self.monthly = storeManager.getProductInfo(productID: storeManager.productIDs[1])
                
                if selectedSub == .weekly {
                    selectProduct = storeManager.getProductInfo(productID: storeManager.productIDs[0])
                }
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
