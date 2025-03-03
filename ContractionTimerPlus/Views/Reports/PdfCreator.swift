//
//  PdfCreator.swift
//  ContractionTimerPlus
//
//  Created by ismail örkler on 26.02.2025.
//
import PDFKit

class PDFCreator {
    var painData: [ReportData]
    var title = "KASILMA GEÇMİŞİ"
    var subtitle = "Kasılma Zamanlayıcısı Contraction Timer 9M +"
    var logoImage: UIImage? = UIImage(named: "logo") // 🔹 Logoyu assetlerden al
    var headers: [String] = []

    var reportDescription = """
    - Bu rapor kasılma sürelerini içermektedir.
    - Süreler anlık olarak kaydedilmiştir.
    - Şiddet bilgisi hastanın beyanına dayalıdır.
    """

    init(painData: [ReportData], title: String, subtitle: String, reportDescription: String, headers: [String] = []) {
        self.painData = painData
        self.title = title
        self.subtitle = subtitle
        self.headers = headers
        self.reportDescription = reportDescription
    }

    func createPDF() -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Contractions Timer",
            kCGPDFContextAuthor: "Contractions Timer 9M +"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let margin: CGFloat = 20
        let rowHeight: CGFloat = 30
        let availableWidth = pageWidth - (2 * margin)

        let font = UIFont.systemFont(ofSize: 12)
        var columnWidths = headers.map { getTextWidth(text: $0, font: font) }

        for row in painData {
            let rowValues = [
                "\(row.processNo)", row.processStartTime, row.processEndTime, row.processDateDifferent, row.painIntensity
            ]
            for (index, value) in rowValues.enumerated() {
                let textWidth = getTextWidth(text: value, font: font)
                columnWidths[index] = max(columnWidths[index], textWidth)
            }
        }

        let totalWidth = columnWidths.reduce(0, +)
        if totalWidth > availableWidth {
            let scaleFactor = availableWidth / totalWidth
            columnWidths = columnWidths.map { $0 * scaleFactor }
        }

        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)
        let data = renderer.pdfData { context in
            var pageNumber = 1
            var currentY: CGFloat = 120

            func addPageNumber() {
                let pageNumberText = "\(pageNumber)"
                let font = UIFont.systemFont(ofSize: 12)
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: UIColor.darkGray
                ]
                let textSize = (pageNumberText as NSString).size(withAttributes: attributes)
                let pageNumberRect = CGRect(
                    x: pageWidth - textSize.width - margin,
                    y: pageHeight - textSize.height - margin,
                    width: textSize.width,
                    height: textSize.height
                )
                (pageNumberText as NSString).draw(in: pageNumberRect, withAttributes: attributes)
            }

            func drawPageHeader() {
                context.beginPage()
                currentY = 120

                let titleFont = UIFont.boldSystemFont(ofSize: 18)
                let subtitleFont = UIFont.systemFont(ofSize: 14)
                let descriptionFont = UIFont.systemFont(ofSize: 12)

                let logoSize = CGSize(width: 60, height: 60)
                let logoRect = CGRect(x: margin, y: 20, width: logoSize.width, height: logoSize.height)
                if let logo = logoImage {
                    logo.draw(in: logoRect)
                }

                let titleX = logoRect.maxX + 10
                let titleWidth = 250.0

                let titleRect = CGRect(x: titleX, y: 25, width: titleWidth, height: 20)
                drawLeftAlignedText(text: title, rect: titleRect, font: titleFont, textColor: .black)

                let subtitleRect = CGRect(x: titleX, y: 45, width: titleWidth, height: 15)
                drawLeftAlignedText(text: subtitle, rect: subtitleRect, font: subtitleFont, textColor: .darkGray)

                let descriptionX = pageWidth - 250 - margin
                let descriptionWidth = 250.0
                let descriptionRect = CGRect(x: descriptionX, y: 20, width: descriptionWidth, height: 60)
                drawLeftAlignedText(text: reportDescription, rect: descriptionRect, font: descriptionFont, textColor: .black)

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yy-MM-dd HH:mm"
                let currentDate = dateFormatter.string(from: Date())

                let dateRect = CGRect(x: descriptionX, y: 90, width: descriptionWidth, height: 15)
                drawLeftAlignedText(text: "Date: \(currentDate)", rect: dateRect, font: descriptionFont, textColor: .black)

                var currentX = margin
                UIColor.black.setFill()
                UIRectFill(CGRect(x: margin, y: currentY, width: availableWidth, height: rowHeight))

                for (index, text) in headers.enumerated() {
                    let rect = CGRect(x: currentX, y: currentY, width: columnWidths[index], height: rowHeight)
                    drawCenteredText(text: text, rect: rect, font: UIFont.boldSystemFont(ofSize: 12), textColor: .white)
                    currentX += columnWidths[index]
                }
                currentY += rowHeight
            }

            drawPageHeader()

            let maxRowsPerPage = Int((pageHeight - currentY - 50) / rowHeight)

            for (index, pain) in painData.enumerated() {
                if index > 0 && index % maxRowsPerPage == 0 {
                    addPageNumber()
                    pageNumber += 1
                    drawPageHeader()
                }

                let bgColor: UIColor = (index % 2 == 0) ? UIColor.lightGray : UIColor.white
                bgColor.setFill()
                UIRectFill(CGRect(x: margin, y: currentY, width: availableWidth, height: rowHeight))

                let rowValues: [String] = [
                    "\(pain.processNo)", pain.processStartTime, pain.processEndTime, pain.processDateDifferent, pain.painRange, pain.painIntensity
                ]

                var currentX = margin
                for (columnIndex, text) in rowValues.enumerated() {
                    let rect = CGRect(x: currentX, y: currentY, width: columnWidths[columnIndex], height: rowHeight)
                    drawCenteredText(text: text, rect: rect, font: font, textColor: .black)
                    currentX += columnWidths[columnIndex]
                }
                currentY += rowHeight
            }

            addPageNumber()
        }

        return data
    }
    
    private func getTextWidth(text: String, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        return (text as NSString).size(withAttributes: attributes).width + 20
    }

    private func drawLeftAlignedText(text: String, rect: CGRect, font: UIFont, textColor: UIColor) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byWordWrapping

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]

        let textSize = (text as NSString).boundingRect(
            with: CGSize(width: rect.width, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        ).size

        let adjustedRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: textSize.height)

        (text as NSString).draw(in: adjustedRect, withAttributes: attributes)
    }

    private func drawCenteredText(text: String, rect: CGRect, font: UIFont, textColor: UIColor) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor,
            .paragraphStyle: createCenteredParagraphStyle()
        ]
        let textSize = (text as NSString).size(withAttributes: attributes)
        let centeredRect = CGRect(
            x: rect.origin.x + (rect.width - textSize.width) / 2,
            y: rect.origin.y + (rect.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        (text as NSString).draw(in: centeredRect, withAttributes: attributes)
    }

    private func createCenteredParagraphStyle() -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return paragraphStyle
    }
}






/*
import PDFKit

class PDFCreator {
    var painData: [ReportData]
    var title = "KASILMA GEÇMİŞİ"
    var subtitle = "Kasılma Zamanlayıcısı Contraction Timer 9M +"

    init(painData: [ReportData], title: String, subtitle: String) {
        self.painData = painData
        self.title = title
        self.subtitle = subtitle
    }

    func createPDF() -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Contractions Timer",
            kCGPDFContextAuthor: "Contractions Timer 9M +"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)

        let data = renderer.pdfData { context in
            context.beginPage()

            let titleFont = UIFont.boldSystemFont(ofSize: 20)
            let subtitleFont = UIFont.systemFont(ofSize: 14)

            let titleRect = CGRect(x: 20, y: 20, width: pageWidth - 40, height: 30)
            title.draw(in: titleRect, withAttributes: [.font: titleFont])

            let subtitleRect = CGRect(x: 20, y: 50, width: pageWidth - 40, height: 20)
            subtitle.draw(in: subtitleRect, withAttributes: [.font: subtitleFont])

            let startY: CGFloat = 100
            let columnWidth: CGFloat = (pageWidth - 40) / 6
            let rowHeight: CGFloat = 30

            let headers = ["No", "Başlat", "Bitiş", "Süre", "Şiddet"]
            var currentY = startY

            // Başlık satırı
            UIColor.black.setFill()
            UIRectFill(CGRect(x: 20, y: currentY, width: pageWidth - 40, height: rowHeight))

            headers.enumerated().forEach { index, text in
                let rect = CGRect(x: 20 + (CGFloat(index) * columnWidth), y: currentY, width: columnWidth, height: rowHeight)
                text.draw(in: rect, withAttributes: [.font: UIFont.boldSystemFont(ofSize: 12), .foregroundColor: UIColor.white])
            }
            currentY += rowHeight

            for (index, pain) in painData.enumerated() {
                let bgColor: UIColor = (index % 2 == 0) ? UIColor.lightGray : UIColor.white
                bgColor.setFill()
                UIRectFill(CGRect(x: 20, y: currentY, width: pageWidth - 40, height: rowHeight))

                // 🔥 TÜM DEĞERLERİ STRING'E ÇEVİRİYORUZ! 🔥
                let rowValues: [String] = [
                    "\(pain.processNo)",         // 🔥 `Int` → `String`
                    pain.processStartTime,
                    pain.processEndTime,
                    pain.processDateDifferent,
                    pain.painIntensity
                ]

                rowValues.enumerated().forEach { columnIndex, text in
                    let rect = CGRect(x: 20 + (CGFloat(columnIndex) * columnWidth), y: currentY, width: columnWidth, height: rowHeight)
                    text.draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 12)]) // ✅ ARTIK HATA VERMEYECEK
                }
                currentY += rowHeight
            }
        }
        return data
    }
}

*/

/*
class PDFCreator {
    var painData: [ReportData]
    var title = "KASILMA GEÇMİŞİ"
    var subtitle = "Kasılma Zamanlayıcısı Contraction Timer 9M +"

    init(painData: [ReportData], title: String, subtitle: String)
    {
        self.painData = painData
        self.title = title
        self.subtitle = subtitle
    }

    func createPDF() -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Contractions Timer",
            kCGPDFContextAuthor: "Contractions Timer 9M +"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)

        let data = renderer.pdfData { context in
            context.beginPage()

            let titleFont = UIFont.boldSystemFont(ofSize: 20)
            let subtitleFont = UIFont.systemFont(ofSize: 14)

            let titleRect = CGRect(x: 20, y: 20, width: pageWidth - 40, height: 30)
            title.draw(in: titleRect, withAttributes: [.font: titleFont])

            let subtitleRect = CGRect(x: 20, y: 50, width: pageWidth - 40, height: 20)
            subtitle.draw(in: subtitleRect, withAttributes: [.font: subtitleFont])

            let startY: CGFloat = 100
            let columnWidth: CGFloat = (pageWidth - 40) / 4
            let rowHeight: CGFloat = 30

            let headers = ["No", "Başlat", "Bitiş", "Süre", "Şiddet"]
            var currentY = startY

            // Çizgi ve Arka Plan Renkleri
            UIColor.black.setFill()
            UIRectFill(CGRect(x: 20, y: currentY, width: pageWidth - 40, height: rowHeight))

            headers.enumerated().forEach { index, text in
                let rect = CGRect(x: 20 + (CGFloat(index) * columnWidth), y: currentY, width: columnWidth, height: rowHeight)
                text.draw(in: rect, withAttributes: [.font: UIFont.boldSystemFont(ofSize: 12), .foregroundColor: UIColor.white])
            }
            currentY += rowHeight

            for (index, pain) in painData.enumerated() {
                let bgColor: UIColor = (index % 2 == 0) ? UIColor.lightGray : UIColor.white
                bgColor.setFill()
                UIRectFill(CGRect(x: 20, y: currentY, width: pageWidth - 40, height: rowHeight))

                //let startTime = dateFormatter.string(from: pain.processStartTime)
                //let endTime = pain.processEndTime != nil ? dateFormatter.string(from: pain.processEndTime!) : "-"
                //let duration = pain.processEndTime != nil ? "\(Int(pain.processEndTime!.timeIntervalSince(pain.processStartTime))) sn" : "-"
                //let intensity = pain.painIntensity != nil ? "\(pain.painIntensity!)" : "-"

                //let rowValues = [pain.processStartTime, pain.processEndTime, pain.processDateDifferent, pain.painIntensity]
                let rowValues = [pain.processNo, pain.processStartTime, pain.processEndTime, pain.processDateDifferent, pain.painIntensity]

                rowValues.enumerated().forEach { columnIndex, text in
                    let rect = CGRect(x: 20 + (CGFloat(columnIndex) * columnWidth), y: currentY, width: columnWidth, height: rowHeight)
                    (text as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
                }
                currentY += rowHeight
            }
        }
        return data
    }
}
*/
