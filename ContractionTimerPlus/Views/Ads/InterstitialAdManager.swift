//
//  InterstitialAdManager.swift
//  ContactionTimer
//
//  Created by ismail örkler on 23.02.2025.
//

import GoogleMobileAds
import SwiftUI

class InterstitialAdManager: NSObject, FullScreenContentDelegate, ObservableObject {
    @Published var isAdReady = false
    private var interstitial: InterstitialAd?
    private let adUnitID = "/ca-app-pub-3940256099942544/1033173712" // Google Ad Manager Test ID

    override init() {
        super.init()
        loadInterstitialAd()
    }

    // Interstitial reklamı yükleme fonksiyonu
    func loadInterstitialAd() {
        let request = AdManagerRequest()
        InterstitialAd.load(with: adUnitID, request: request) { ad, error in
            if let error = error {
                print("❌ Interstitial Reklam Yükleme Hatası: \(error.localizedDescription)")
                self.isAdReady = false
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
            self.isAdReady = true
            print("✅ Interstitial Reklam Yüklendi!")
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

    // Reklam gösterildikten sonra çağrılır
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("✅ Reklam kapatıldı, yeni reklam yükleniyor...")
        loadInterstitialAd()
    }
}
