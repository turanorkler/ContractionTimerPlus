//
//  PdfView.swift
//  ContractionTimerPlus
//
//  Created by ismail örkler on 26.02.2025.
//
import SwiftUI
import PDFKit

// PDF verisini sarmalayan Identifiable yapı
struct PDFWrapper: Identifiable {
    let id = UUID()
    let data: Data
}

struct PDFView: View {
    @State private var pdfData: PDFWrapper?

    let painData: [PainIntensity] = [
        PainIntensity(processNo: 1, processStartTime: Date(), processEndTime: Date().addingTimeInterval(180), painIntensity: 5),
        PainIntensity(processNo: 2, processStartTime: Date().addingTimeInterval(-600), processEndTime: Date().addingTimeInterval(-420), painIntensity: 7),
        PainIntensity(processNo: 3, processStartTime: Date().addingTimeInterval(-1200), processEndTime: nil, painIntensity: nil)
    ]

    var body: some View {
        VStack {
            Button("PDF Oluştur ve İndir") {
                let generatedPDF = PDFCreator(painData: painData).createPDF()
                pdfData = PDFWrapper(data: generatedPDF) // Identifiable türüne dönüştürüyoruz
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .sheet(item: $pdfData) { pdf in
            PdfActivityView(activityItems: [pdf.data]) // İçindeki `Data`'yı alıyoruz
        }
    }
}
