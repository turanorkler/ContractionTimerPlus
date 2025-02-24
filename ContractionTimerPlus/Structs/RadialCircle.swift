//
//  RadialCircle.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//
import SwiftUI

struct RadialCircle: View {
    var position: CGPoint
    var size: CGFloat
    
    var body: some View {
        RadialGradient(
            gradient: Gradient(colors: [
                Color.white.opacity(0.9),  // Merkez: Beyaz
                Color.white.opacity(0.0)   // Dış kısım: Şeffaf
            ]),
            center: .center,
            startRadius: 0,
            endRadius: size / 2
        )
        .frame(width: size, height: size)
        .position(position) // 📌 Belirtilen noktaya yerleştir
    }
}
