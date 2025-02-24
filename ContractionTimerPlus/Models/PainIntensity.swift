//
//  Contracts.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 22.02.2025.
//
import SwiftData
import Foundation

@Model
class PainIntensity{
    @Attribute(.unique) var processNo: Int // Otomatik artan numara
    var processStartTime: Date
    var processEndTime: Date?
    var painIntensity: Int?

    init(processNo: Int = 0, processStartTime: Date, processEndTime: Date? = nil, painIntensity: Int? = nil) {
        self.processNo = processNo
        self.processStartTime = processStartTime
        self.processEndTime = processEndTime
        self.painIntensity = painIntensity
    }
}
