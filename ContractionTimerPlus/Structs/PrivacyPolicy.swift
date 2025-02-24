//
//  CustomButtonView.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//
import SwiftUI

struct PrivacyPolicy: View {
    
    let color: Color

    init(color: Color = .black) {
        self.color = color
    }
    
    var body: some View {
        HStack(alignment: .center)
        {
            Button(action: {
                if let url = URL(string: "https://www.privacypolicy.com") {
                    UIApplication.shared.open(url)
                }
            })
            {
                Text("Privacy Policy".localized)
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(color)
            }
            
            Divider()
                .frame(width: 1, height: 12)
                .background(color)
            
            Button(action: {
                if let url = URL(string: "https://www.termsofuse.com") {
                    UIApplication.shared.open(url)
                }
            })
            {
                Text("Terms of Use".localized)
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(color)
            }
            
        }
        
        .padding(.top, 10)
    }
}

#Preview {
    PrivacyPolicy(color: .black)
}
