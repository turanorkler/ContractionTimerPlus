//
//  PdfViewKit.swift
//  ContractionTimerPlus
//
//  Created by ismail örkler on 14.03.2025.
//
import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    let pdfName: String

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true

        if let url = Bundle.main.url(forResource: pdfName, withExtension: "pdf"),
           let document = PDFDocument(url: url) {
            pdfView.document = document
        }

        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}
