//
//  ToogleView.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//

import SwiftUI

struct GeneralButton2: View {
    var isActive: Bool
    var action: () -> Void

    var body: some View {
        Button(action : {
            action()
        }) {
            ZStack {
                
                
                Rectangle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(
                                colors: isActive ? [.redredial1, .redredial2] : [.greenradial, .greenradial1]
                            ),
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .cornerRadius(10)
                
                if isActive {
                    Text("Contraction_Stopped".localized)
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        
                } else {
                    Text("Contraction_Started".localized)
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        
                }
                
            }
        }
    }
}

#Preview {
    GeneralButton2(isActive: false)
    {
        
    }
}
