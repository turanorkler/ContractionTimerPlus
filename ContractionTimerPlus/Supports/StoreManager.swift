//
//  StoreManager.swift
//  pulseven
//
//  Created by ismail örkler on 14.02.2025.
//

import SwiftUI
import StoreKit

@MainActor
class StoreManager: ObservableObject {
    
    static let shared = StoreManager()
    @ObservedObject var contants = Constants.shared
    
    private let userDefaults = UserDefaults.standard
    @Published var products: [Product] = []
    @Published var purchasedSubscription: Product? // Mevcut satın alınmış abonelik
    @Published var isSubscriptionName : String = ""
    @Published var transactionID : String = ""
    @Published var originalTransactionID : String = ""
    @Published var isSubscriptionActive = false
    @Published var showPaywall = false // Paywall'ı göstermek için
    
    let productIDs = [
          "com.trn.contractionsTimer.weeklynew",
          "com.trn.contractionsTimer.monthly",
          "com.trn.contractionsTimer.monthly3dayfree",
          "com.trn.contractionsTimer.weekly3dayfree"
    ]
    
    init() {
        Task {
            await fetchProducts()
            await checkSubscriptionStatus()
        }
    }
    
    // Ürünleri yükler
    func fetchProducts() async {
        do {
            let fetchedProducts = try await Product.products(for: productIDs)
            self.products = fetchedProducts // Artık DispatchQueue.main.async'a gerek yok
        } catch {
            print("Ürünler yüklenirken hata oluştu: \(error)")
        }
    }
    
    func getProductInfo(productID: String) -> Product? {
        return products.first(where: { $0.id == productID })
    }
    
    // Satın alma işlemi
    func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            if case .verified(let transaction) = verification {
                await transaction.finish()
                self.purchasedSubscription = product
                self.isSubscriptionActive = true
                contants.fullScreenCover = nil // açık paywalları kapatır...
                self.showPaywall = false // Paywall'ı kapat
                return true
            }
        case .userCancelled:
            print("Kullanıcı satın almayı iptal etti.")
            self.showPaywall = false // Paywall'ı kapat
            return false
        default:
            self.showPaywall = false // Paywall'ı kapat
            return false
        }
        
        return false
    }
    
    // Geri yükleme işlemi
    func restorePurchases() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                let productID = transaction.productID
                if let product = products.first(where: { $0.id == productID }) {
                    self.purchasedSubscription = product
                    self.isSubscriptionActive = true
                }
            }
        }
        self.showPaywall = false // Paywall'ı kapat
    }
    
    // Abonelik durumunu kontrol et
    func checkSubscriptionStatus() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                let productID = transaction.productID
                if let product = products.first(where: { $0.id == productID }) {
                    self.purchasedSubscription = product
                    
                    self.transactionID = "\(transaction.id)"
                    self.originalTransactionID = "\(transaction.originalID)"
                    
                    if let idm = self.purchasedSubscription?.id {
                        if idm == productIDs[0] || idm == productIDs[3]
                        {
                            self.isSubscriptionName = "Premium_Weekly_Sub"
                        } else {
                            self.isSubscriptionName = "Premium_Yearly_Sub"
                        }
                    }
                    self.isSubscriptionActive = true
                    return
                }
            }
        }
        self.isSubscriptionActive = false
    }
}
