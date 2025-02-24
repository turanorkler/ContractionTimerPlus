//
//  LanguageManager.swift
//  pulseven
//
//  Created by ismail örkler on 6.02.2025.
//
import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    
    static let shared = LanguageManager()
    @Published var selectedLanguage: String
    @Published var showLanguageSheet: Bool = false // 🔥 Sheet kontrolü buraya ekledik
    @Published var forceRefresh: Bool = false // 🔥 View güncellemek için

    init() {
        self.selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ??
                                Locale.current.language.languageCode?.identifier ?? "en"
    }
    
    func changeLanguage(to code: String) {
        UserDefaults.standard.setValue(code, forKey: "selectedLanguage")
        //UserDefaults.standard.setValue([code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        showLanguageSheet = false
        self.selectedLanguage = code
    }
    
}
