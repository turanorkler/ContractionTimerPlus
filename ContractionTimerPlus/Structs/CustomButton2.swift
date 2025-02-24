//
//  CustomButtonView.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//
import SwiftUI

struct CustomButton2: View {
    var icon: String?
    var systemImage: String?
    var buttonText: String
    var action: (() -> Void)? = nil

    var body: some View {
        Button(action: { action?() }) {
            HStack {
                if let icon = icon, !icon.isEmpty {
                    Image(icon)
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                
                else if let systemImage = systemImage, !systemImage.isEmpty {
                    Image(systemName: systemImage)
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 20, height: 25)
                }
                
                Text(buttonText)
                    .font(.custom("Poppins-Medium", size: 15))
                    .foregroundColor(.splashcolor1)
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(.white)
            .cornerRadius(15)
        }
    }
}

#Preview {
    CustomButton2(buttonText: "Next") {
        
    }
}

