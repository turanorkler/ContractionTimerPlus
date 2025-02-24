//
//  PdfCreator.swift
//  ContractionTimerPlus
//
//  Created by ismail örkler on 26.02.2025.
//

import PDFKit

class PDFCreator {
    var painData: [PainIntensity]

    init(painData: [PainIntensity]) {
        self.painData = painData
    }

    func createPDF() -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "PDF Creator",
            kCGPDFContextAuthor: "SwiftUI App"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)

        let data = renderer.pdfData { context in
            context.beginPage()

            let title = "KASILMA GEÇMİŞİ"
            let subtitle = "Kasılma Zamanlayıcısı Contraction Timer 9M +"
            let titleFont = UIFont.boldSystemFont(ofSize: 20)
            let subtitleFont = UIFont.systemFont(ofSize: 14)

            let titleRect = CGRect(x: 20, y: 20, width: pageWidth - 40, height: 30)
            title.draw(in: titleRect, withAttributes: [.font: titleFont])

            let subtitleRect = CGRect(x: 20, y: 50, width: pageWidth - 40, height: 20)
            subtitle.draw(in: subtitleRect, withAttributes: [.font: subtitleFont])

            let startY: CGFloat = 100
            let columnWidth: CGFloat = (pageWidth - 40) / 4
            let rowHeight: CGFloat = 30

            let headers = ["Başlat", "Bitiş", "Süre", "Şiddet"]
            var currentY = startY

            // Çizgi ve Arka Plan Renkleri
            UIColor.black.setFill()
            UIRectFill(CGRect(x: 20, y: currentY, width: pageWidth - 40, height: rowHeight))

            headers.enumerated().forEach { index, text in
                let rect = CGRect(x: 20 + (CGFloat(index) * columnWidth), y: currentY, width: columnWidth, height: rowHeight)
                text.draw(in: rect, withAttributes: [.font: UIFont.boldSystemFont(ofSize: 12), .foregroundColor: UIColor.white])
            }
            currentY += rowHeight

            // Tablo Satırları
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss dd.MM.yyyy"

            for (index, pain) in painData.enumerated() {
                let bgColor: UIColor = (index % 2 == 0) ? UIColor.lightGray : UIColor.white
                bgColor.setFill()
                UIRectFill(CGRect(x: 20, y: currentY, width: pageWidth - 40, height: rowHeight))

                let startTime = dateFormatter.string(from: pain.processStartTime)
                let endTime = pain.processEndTime != nil ? dateFormatter.string(from: pain.processEndTime!) : "-"
                let duration = pain.processEndTime != nil ? "\(Int(pain.processEndTime!.timeIntervalSince(pain.processStartTime))) sn" : "-"
                let intensity = pain.painIntensity != nil ? "\(pain.painIntensity!)" : "-"

                let rowValues = [startTime, endTime, duration, intensity]

                rowValues.enumerated().forEach { columnIndex, text in
                    let rect = CGRect(x: 20 + (CGFloat(columnIndex) * columnWidth), y: currentY, width: columnWidth, height: rowHeight)
                    text.draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
                }
                currentY += rowHeight
            }
        }
        return data
    }
}
