//
//  LanguageSelectionView.swift
//  pulseven
//
//  Created by ismail örkler on 6.02.2025.
//
import SwiftUI

struct LanguageSelectionView: View {
    
    @StateObject var constants = Constants.shared
    @StateObject var lm = LanguageManager.shared
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        
        ForEach(constants.languages, id: \.1) { flag, language, lang in
            Button(action: {
                //selectedLanguage = language
                //selectedFlag = flag
                lm.changeLanguage(to: lang)
                
            }) {
                HStack {
                    Text("\(flag) \(language)")
                        .font(.custom("Poppins-Medium", size: 15))
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.horizontal, 10)
                .padding(.top, 5)
            }
            Divider() // Her öğe arasına çizgi
                .background(Color.black)
        }
        .navigationTitle("Language_Change".localized)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel".localized) { dismiss() }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
        
}


#Preview {
    LanguageSelectionView()
}
