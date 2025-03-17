//
//  Constants.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//

import Foundation
import Combine
import UIKit
import StoreKit

class Constants: ObservableObject {
    static let shared = Constants()
    
    @Published var painLists: [PainIntensity] = []
    
    @Published var isPay : Bool = true
    
    @Published var fullScreenCover : FullScreenEnum? = nil
    @Published var popUpCover : FullScreenEnum? = nil
    
    @Published var isDarkMode: Bool = false
    
    @Published var appStoreLink: String = "https://apps.apple.com/us/app/contraction-timer-plus-9m/id1548444444"
    @Published var termsofuse: String = "https://contraction-timer.blogspot.com/p/terms-of-use.html"
    @Published var privacypolicy: String = "https://contraction-timer.blogspot.com/p/privacy-policy.html"
    @Published var support: String = "https://contraction-timer.blogspot.com/p/contacts.html"
    
    @Published var showUseFullTips: Bool {
        didSet {
            UserDefaults.standard.set(showUseFullTips, forKey: "showUseFullTips") // Kullanıcı değeri değiştirirse kaydet
        }
    }
    
    @Published var contractionIntensity : Bool {
        didSet {
            UserDefaults.standard.set(contractionIntensity, forKey: "contractionIntensity") // Kullanıcı değeri değiştirirse kaydet
        }
    }

    private init() {
        if UserDefaults.standard.object(forKey: "showUseFullTips") == nil {
            // Eğer daha önce kaydedilmemişse varsayılan olarak `true` ayarla
            UserDefaults.standard.set(true, forKey: "showUseFullTips")
        }
        self.showUseFullTips = UserDefaults.standard.bool(forKey: "showUseFullTips")
        
        if UserDefaults.standard.object(forKey: "contractionIntensity") == nil {
            // Eğer daha önce kaydedilmemişse varsayılan olarak `true` ayarla
            UserDefaults.standard.set(true, forKey: "contractionIntensity")
        }
        self.contractionIntensity = UserDefaults.standard.bool(forKey: "contractionIntensity")
    }

    let languages = [
        ("🇺🇸", "English", "en"),
        ("🇫🇷", "France", "fr"),
        ("🇩🇪", "German", "de"),
        ("🇪🇸", "Spanish", "es"),
        ("🇹🇷", "Turkish", "tr"),
        ("🇷🇺", "Russian", "ru"),
        ("🇯🇵", "Japan", "ja"),
        ("🇨🇳", "Chinese", "zh"),
        ("🇸🇦", "Arabic", "ar")
    ]
    
    let paywallMessages = [
        "paywall_1",
        "paywall_2",
        "paywall_3",
        "paywall_4"
    ]
    
    func sendEmail(subject: String, body: String, emailRecipients: [String] = [])
    {
        if emailRecipients.count <= 0 { return }
        
        let recipients = emailRecipients.joined(separator: ",")
        let mailURL = "mailto:\(recipients)?subject=\(subject)&body=\(body)"
        
        if let encodedURL = mailURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedURL) {
            UIApplication.shared.open(url)
        }
    }
    
    func sendSMS(message: String, smsRecipients: [String] = [])
    {
        if smsRecipients.count <= 0 { return }
        let recipients = smsRecipients.joined(separator: ",")
        
        let smsURL = "sms:\(recipients)&body=\(message)"
        
        if let encodedURL = smsURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedURL) {
            UIApplication.shared.open(url)
        }
    }
    
    func getBannerAdsID() -> String {
        /*
         #if DEBUG
        // DEBUG modunda test reklam kimliği
        return "ca-app-pub-3940256099942544/2934735716"
        #else
        // RELEASE modunda, App Store veya TestFlight kontrolü
        if AppState.shared.isAppStore {
            // App Store'da gerçek reklam kimliği
            return "ca-app-pub-4755969652035514/5821116971"
        } else {
            // TestFlight veya diğer RELEASE ortamlarında test reklam kimliği
            return "ca-app-pub-3940256099942544/2934735716"
        }
        #endif
         */
        return "ca-app-pub-4755969652035514/5821116971"
    }
    
    func getInterstitialAdsID() -> String {
        /*
         #if DEBUG
        // DEBUG modunda test reklam kimliği
            return "ca-app-pub-3940256099942544/1033173712"
        #else
        // RELEASE modunda, App Store veya TestFlight kontrolü
        if AppState.shared.isAppStore {
            // App Store'da gerçek reklam kimliği
            return "ca-app-pub-4755969652035514/9704521666"
        } else {
            // TestFlight veya diğer RELEASE ortamlarında test reklam kimliği
            return "ca-app-pub-3940256099942544/1033173712"
        }
        #endif
        */
        return "ca-app-pub-4755969652035514/9704521666"
    }

}

