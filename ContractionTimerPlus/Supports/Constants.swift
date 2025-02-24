//
//  Constants.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//

import Foundation
import Combine

class Constants: ObservableObject {
    static let shared = Constants()
    //@Published var username: String = "Misafir"
    @Published var isPay : Bool = true
    
    @Published var fullScreenCover : FullScreenEnum? = nil
    @Published var popUpCover : FullScreenEnum? = nil
    
    @Published var isDarkMode: Bool = false
    
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
        ("🇺🇸", "English - US", "en"),
        ("🇪🇸", "Spanish - ES", "es"),
        ("🇹🇷", "Turkish - TR", "tr"),
        ("🇷🇺", "Russian - RU", "ru"),
        ("🇸🇦", "Arabic - AR", "ar")
    ]
    
    let paywallMessages = [
        "❤️  Most seamless contraction timer on the market!",
        "🍼  Keep & share your contractions report easily",
        "🌸  Useful tips & articles just in time!",
        "📫  Emergency texts to people with only one tap!"
    ]
}

