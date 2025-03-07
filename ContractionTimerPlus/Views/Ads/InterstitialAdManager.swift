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

    override init() {
        super.init()
        loadInterstitialAd()
    }

    // Interstitial reklamı yükleme fonksiyonu
    func loadInterstitialAd() {
        let request = Request()
        InterstitialAd.load(with: Constants.shared.getInterstitialAdsID(), request: request) { ad, error in
            if let error = error {
                print("❌ Interstitial Reklam Yükleme Hatası: \(error.localizedDescription)")
                self.isAdReady = false
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
            self.isAdReady = true
            print("✅ Interstitial Reklam Yüklendi! - \(Constants.shared.getInterstitialAdsID())")
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


