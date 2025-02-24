//
//  Contracts.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 22.02.2025.
//
import SwiftData
import Foundation

class ReportData {
    var processNo: Int // Otomatik artan numara
    var processStartTime: Date
    var processEndTime: Date?
    var painIntensity: Int?
    var processDateDifferent: TimeInterval? // processStartTime ile processEndTime arasındaki fark
    var painRange: TimeInterval? // Bir önceki ReportData ile arasındaki fark

    init(processNo: Int = 0, processStartTime: Date, processEndTime: Date? = nil, painIntensity: Int? = nil, previousReport: ReportData? = nil) {
        self.processNo = processNo
        self.processStartTime = processStartTime
        self.processEndTime = processEndTime
        self.painIntensity = painIntensity

        // processStartTime ile processEndTime arasındaki farkı hesapla
        if let endTime = processEndTime {
            self.processDateDifferent = endTime.timeIntervalSince(processStartTime)
        } else {
            self.processDateDifferent = nil
        }

        // Bir önceki öğe varsa, aralarındaki zaman farkını hesapla
        if let previous = previousReport {
            self.painRange = processStartTime.timeIntervalSince(previous.processStartTime)
        } else {
            self.painRange = nil
        }
    }
}
