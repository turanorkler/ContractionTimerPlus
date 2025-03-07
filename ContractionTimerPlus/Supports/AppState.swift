//
//  AppState.swift
//  ContractionTimerPlus
//
//  Created by ismail örkler on 7.03.2025.
//

import Foundation
import StoreKit

class AppState {
    static let shared = AppState()
    
    // Ortam bilgisini saklamak için bir değişken
    var isAppStore: Bool = false
    
    // Uygulama başlangıcında ortam bilgisini hesapla
    func initialize() async {
        isAppStore = await isAppStoreBuild()
    }
    
    // App Store kontrolü için yardımcı metod
    private func isAppStoreBuild() async -> Bool {
        if #available(iOS 18.0, *) {
            do {
                let verificationResult = try await AppTransaction.shared
                
                guard case .verified(let appTransaction) = verificationResult else {
                    print("AppTransaction doğrulanamadı.")
                    return false
                }
                
                if appTransaction.environment == .sandbox {
                    return false
                }
                
                return true
            } catch {
                print("AppTransaction hatası: \(error.localizedDescription)")
                return false
            }
        } else {
            // iOS 17 ve önceki sürümler için eski yöntem
            if let receiptURL = Bundle.main.appStoreReceiptURL {
                return !receiptURL.lastPathComponent.contains("sandbox")
            }
            return false
        }
    }
}
