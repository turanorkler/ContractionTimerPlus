//
//  Alarm.swift
//  ContractionTimerPlus
//
//  Created by ismail örkler on 6.03.2025.
//

extension Array where Element == Int {
    func isStrictlyIncreasing() -> Bool {
        zip(self, self.dropFirst()).allSatisfy { $0.0 < $0.1 }
    }
    
    func isNonDecreasing() -> Bool {
        zip(self, self.dropFirst()).allSatisfy { $0.0 <= $0.1 }
    }
}
