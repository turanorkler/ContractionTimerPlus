//
//  ToogleView.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//

import SwiftUI

struct GeneralButton: View {
    var isActive: Bool
    var action: () -> Void

    var body: some View {
        Button(action : {
            action()
        }) {
            ZStack {
                Circle()
                    .fill(.grayf3)
                    .frame(width: 120, height: 120)
                
                Circle()
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
                    .frame(width: 100, height: 100)
                
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [.white.opacity(0.2), .clear]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 40
                        )
                    )
                    .frame(width: 100, height: 100)
                
                if isActive {
                    Text("Contraction_Stopped".localized)
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                } else {
                    Text("Contraction_Started".localized)
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                }
                
            }
        }
    }
}

#Preview {
    GeneralButton(isActive: false)
    {
        
    }
}
