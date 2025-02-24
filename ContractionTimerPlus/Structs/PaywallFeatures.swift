//
//  CustomButtonView.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//
import SwiftUI

struct PaywallFeatures: View {
    
    @ObservedObject var constants = Constants.shared
    
    let color : Color
    
    var body: some View {
        HStack
        {
            VStack(alignment: .leading, spacing: 10) {
                
                ForEach(constants.paywallMessages, id: \.self) { message in
                    Text(message)
                        .font(.custom("Poppins-Medium", size: 16))
                        .foregroundColor(color)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}

#Preview {
    PaywallFeatures(color: .black)
}
