//
//  ToogleView.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//

import SwiftUI

struct ToggleButton: View {
    var title: String
    var price: String
    var isActive: Bool // 📌 Burada sadece seçili olup olmadığını kontrol ediyoruz
    var action: () -> Void

    var body: some View {
        ZStack {
            Color.splashcolor1.edgesIgnoringSafeArea(.all)
            Button(action: action)
            {
                VStack(spacing: 0) {
                    
                    HStack(alignment: .top, spacing: 10) {
                        
                        VStack(alignment: .leading,spacing: 0) {
                            Text(title.localized)
                            //.font(.system(size: 16, weight: isActive ? .bold : .regular))
                                .font(.custom("Poppins-Medium", size: 19))
                                .foregroundColor(isActive ? .splashcolor1 : .white)
                                .cornerRadius(10)
                            
                            Text(price)
                                //.font(.system(size: 16, weight: isActive ? .bold : .regular))
                                .font(.custom("Poppins-Medium", size: 22))
                                .foregroundColor(isActive ? .splashcolor1 : .white)
                                .cornerRadius(10)
                                .padding(.top, 10)
                        }
                        
                        ZStack {
                            Circle()
                                .stroke(isActive ? .splashcolor1 : .white, lineWidth: 2) // Daire çizgisi
                            
                            if isActive {
                                Image(systemName: "checkmark") // 📌 Seçiliyse check işareti
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.splashcolor1)
                            }
                        }
                        .frame(width: 20, height: 20)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .top)
                    
                }
                
                .frame(maxWidth: .infinity,maxHeight: 100)
                .background(isActive ? .white : .clear)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white, lineWidth: 1)
                )
                
                
            }
            
        }
    }
}

#Preview {
    ToggleButton(title: "Monthly", price: "$10.99", isActive: true)
    {
        
    }
}
