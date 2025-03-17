//
//  PdfViewer.swift
//  ContractionTimerPlus
//
//  Created by ismail örkler on 14.03.2025.
//
import SwiftUI

struct PDFViewer: View {
    
    @StateObject private var constants: Constants = Constants.shared
    
    var pdfName: String

    var body: some View {
        
        ZStack(alignment: .topLeading)
        {
            PDFKitView(pdfName: pdfName)
            
            HStack {
                
                Spacer()
                
                Button(action: {
                    constants.fullScreenCover = nil
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14) // Küçük ikon boyutu
                        .foregroundColor(.white)
                        .padding(10) // İç boşluk ekle
                        .background(Color.black)
                        .clipShape(Circle()) // Arka planı yuvarlak yap
                }
                
                
            }
            .padding(.top, 40)
            .padding(.horizontal, 20)
        }
        .edgesIgnoringSafeArea(.all)
        
    }
}

#Preview {
    PDFViewer(pdfName: "who")
}
