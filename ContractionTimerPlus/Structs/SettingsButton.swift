//
//  ToogleView.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//

import SwiftUI

struct SettingsButton: View {

    let title : String
    
    var body: some View {
        
        HStack {
            Text(title.localized)
                .font(.custom("Poppins-Medium", size: 15))
                .foregroundColor(.black)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(Color.headerbg)
        .cornerRadius(10)
        
    }
}

#Preview {
    SettingsButton(title: "Merhaba")
}
