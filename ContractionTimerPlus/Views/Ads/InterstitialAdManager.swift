//
//  InterstitialAdManager.swift
//  ContactionTimer
//
//  Created by ismail örkler on 23.02.2025.
//

import GoogleMobileAds
import SwiftUI
import UIKit

@MainActor
class InterstitialAdManager: NSObject, FullScreenContentDelegate, ObservableObject {
    
    static let shared = InterstitialAdManager()
    
    @Published var isAdReady = false
    private var interstitial: InterstitialAd?
    
    // DEBUG ve PRODUCTION için farklı reklam ID'leri kullanma
    private let adUnitID: String = {
        #if DEBUG
        return "ca-app-pub-3940256099942544/1033173712" // Google Test ID
        #else
        return "ca-app-pub-4755969652035514/9704521666" // Buraya gerçek reklam ID'nizi girin
        #endif
    }()

    override init() {
        super.init()
        loadInterstitialAd()
    }

    // Interstitial reklamı yükleme fonksiyonu
    func loadInterstitialAd() {
        let request = Request()
        InterstitialAd.load(with: adUnitID, request: request) { ad, error in
            if let error = error {
                print("❌ Interstitial Reklam Yükleme Hatası: \(error.localizedDescription)")
                self.isAdReady = false
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
            self.isAdReady = true
            print("✅ Interstitial Reklam Yüklendi! - \(self.adUnitID)")
        }
    }

    // Reklamı gösterme fonksiyonu
    func showAd(from viewController: UIViewController) {
        if let ad = interstitial {
            ad.present(from: viewController)
        } else {
            print("❌ Reklam hazır değil, yeniden yükleniyor...")
            loadInterstitialAd()
        }
    }

    // Reklam gösterildikten sonra tekrar yüklenmesi için çağrılır
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("✅ Reklam kapatıldı, yeni reklam yükleniyor...")
        loadInterstitialAd()
    }
    
    // **SwiftUI İçin Reklam Gösterme Fonksiyonu**
    func showInterstitialAd() {
        if let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene }) // Aktif olan pencere sahnesini al
            .flatMap({ $0.windows }) // O sahnedeki pencereleri al
            .first(where: { $0.isKeyWindow })?.rootViewController { // Ana pencereyi seç
            showAd(from: rootViewController)
        } else {
            print("❌ Root View Controller bulunamadı.")
        }
    }
}


