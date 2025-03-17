//
//  AppComment.swift
//  ContractionTimerPlus
//
//  Created by ismail örkler on 17.03.2025.
//

import SwiftUI

struct AppComment : View {
    
    @StateObject private var constants = Constants.shared
    
    var fontSize : CGFloat = 15
    
    var body: some View {
        VStack {
        let localizedText = "\("info_text".localized)"
        let localizedLinkText = "info_link".localized

        Text(try! AttributedString(markdown: localizedText))
            .font(.custom("Poppins-Light", size: fontSize))
            .multilineTextAlignment(.center)

        Text(localizedLinkText)
            .font(.custom("Poppins-Light", size: fontSize))
            .foregroundColor(.blue) // Link gibi görünmesi için
            .underline()
            .onTapGesture {
                constants.fullScreenCover = .pdfFile
            }
        }
    }
}


#Preview
{
    
}

