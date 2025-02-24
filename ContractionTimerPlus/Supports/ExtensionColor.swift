//
//  ExtensionColor.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 22.02.2025.
//
import SwiftUI

extension Color {
    static func random() -> Color {
        return Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}
