//
//  Tsp.swift
//  ContractionTimerPlus
//
//  Created by ismail örkler on 3.04.2025.
//

import SwiftUI

extension Font {
    static func tsp(_ baseSize: CGFloat) -> Font {
        let screenSize = UIScreen.main.bounds.size
        let minSide = min(screenSize.width, screenSize.height)

        let scaledSize: CGFloat
        switch minSide {
        case ..<360:
            scaledSize = baseSize * 0.85
        case 360..<400:
            scaledSize = baseSize
        case 400..<600:
            scaledSize = baseSize * 1.1
        default:
            scaledSize = baseSize * 1.25
        }

        return .system(size: scaledSize)
    }
}
