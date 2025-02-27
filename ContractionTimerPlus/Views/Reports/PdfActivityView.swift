//
//  PdfActivityView.swift
//  ContractionTimerPlus
//
//  Created by ismail örkler on 26.02.2025.
//
import SwiftUI

struct PdfActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
