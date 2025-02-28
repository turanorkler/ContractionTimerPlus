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
                if let url = URL(string: "https://contraction-timer.blogspot.com/p/privacy-policy.html") {
                    UIApplication.shared.open(url)
                }
            })
            {
                Text("Privacy_Policy".localized)
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(color)
            }
            
            Divider()
                .frame(width: 1, height: 12)
                .background(color)
            
            Button(action: {
                if let url = URL(string: "https://contraction-timer.blogspot.com/p/terms-of-use.html") {
                    UIApplication.shared.open(url)
                }
            })
            {
                Text("Terms_of_Use".localized)
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
