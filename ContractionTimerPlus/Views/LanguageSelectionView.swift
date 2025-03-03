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
        
        VStack {
            
            HStack {
                Text("Language_Change".localized)
                    .font(.custom("Poppins-Medium", size: 22))
                    .foregroundColor(.greenradial)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                
                //Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                }
                .tint(.black)
                    
            }
            .padding(.top, 50)
            .padding(.horizontal, 20)
            
            VStack(spacing: 0)
            {
                ForEach(constants.languages, id: \.1) { flag, language, lang in
                    
                    Button(action: {
                        //selectedLanguage = language
                        //selectedFlag = flag
                        lm.changeLanguage(to: lang)
                        
                    }) {
                        HStack {
                        
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .tint(lang == lm.selectedLanguage ? .green : .gray)
                            
                            
                            Text(String("\(flag) \(language)"))
                                .font(.custom("Poppins-Medium", size: 16))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                    }
                    Divider() // Her öğe arasına çizgi
                        .background(Color.black)
                    
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
        
}


#Preview {
    LanguageSelectionView()
}
