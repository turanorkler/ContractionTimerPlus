//
//  Localized.swift
//  ContractionTimerPlus
//
//  Created by ismail örkler on 25.02.2025.
//

import Foundation
import SwiftUI

extension String {
    var localized: String {
        let languageCode = LanguageManager.shared.selectedLanguage
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return self
        }
        let translatedString = NSLocalizedString(self, bundle: bundle, comment: "")
        return translatedString.replacingOccurrences(of: "\\n", with: "\n")
    }
}

/*
extension String {
    var localized: String {
        let languageCode = LanguageManager.shared.selectedLanguage
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return self
        }
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
*/

/*
extension String {
    
    func localized(_ languageCode: String) -> String {
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return self
        }
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
*/
