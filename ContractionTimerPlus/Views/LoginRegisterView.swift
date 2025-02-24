//
//  ContentView.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 19.02.2025.
//

import SwiftUI

struct LoginRegisterView: View {
    @State private var selectedLanguage = "English - US"
    @State private var selectedFlag = "🇺🇸"
    @State private var showLanguageList = false
    @State private var email = ""
    @State private var password = ""
    @State private var isMenuOpen = false

    @ObservedObject var constants = Constants.shared
    @ObservedObject var lm = LanguageManager.shared
    @StateObject private var loginViewModel = AuthViewModel.shared
    
    var body: some View {
        ZStack {
            Color.loginregister.edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Image("mail")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.red)

                signUpView
                //languageSelectionView
                
                Spacer()
                
                CustomButton(systemImage: "applelogo", buttonText: "btn_apple_login".localized) {
                    loginViewModel.startSignInWithApple()
                }
                
                CustomButton(icon: "googleicon", buttonText: "btn_google_login".localized)
                {
                    loginViewModel.signInWithGoogle()
                }
                
                
            }
            .padding()
        }
        .navigationDestination(isPresented: $loginViewModel.isLoggedIn) {
            MainView()
        }
        .onAppear {
            
            let lng = constants.languages.first(where: { $0.2 == lm.selectedLanguage })
            selectedFlag = lng?.0 ?? "🇺🇸"
            selectedLanguage = lng?.1 ?? "English - US"

            loginViewModel.checkIfUserIsSignedIn()
        }
        .navigationBarBackButtonHidden(true)
    }

    var signUpView: some View {
        ZStack(alignment: .top) {
            // Ana içerik
            VStack(spacing: 10) {
                Text("Select Language".localized)
                    .foregroundColor(.black)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Dil Seçim Menüsü
                Button(action: {
                    isMenuOpen.toggle() // Popover'ı aç/kapat
                }) {
                    HStack {
                        Text("\(selectedFlag) \(selectedLanguage)")
                            .font(.custom("Poppins-Medium", size: 15))
                            .bold()
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.black)
                    }
                    .padding()
                    .frame(maxWidth: .infinity) // Genişlik tam ekran olacak
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )
                }
                
                // E-posta Alanı
                Text("E-Mail".localized)
                    .font(.custom("Poppins-Medium", size: 15))
                    .foregroundColor(.black)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("E-Mail".localized, text: $email)
                    .font(.custom("Poppins-Medium", size: 15))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                    .keyboardType(.emailAddress)
                    .foregroundColor(.black)
                
                Text("Password".localized)
                    .font(.custom("Poppins-Medium", size: 15))
                    .foregroundColor(.black)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                SecureField("Password".localized, text: $password)
                    .font(.custom("Poppins-Medium", size: 15))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                    .keyboardType(.emailAddress)
                    .foregroundColor(.black)
                
                // Buradaki yapı değiştirilecek ve login işlemiyle bağlanacak normal e-postai için
                
                NavigationLink(destination: MainView())
                {
                    Text("Sign Up".localized)
                        .font(.custom("Poppins-Medium", size: 17))
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
            }
            
            // Açılır Menü (Popover)
            if isMenuOpen {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.loginregister)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1) // Kenarlık rengi siyah
                        )
                        .shadow(radius: 5) // Gölgelendirme ekleyerek daha iyi görünüm sağla
                    
                    // İçerik
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(constants.languages, id: \.1) { flag, language, lang in
                            Button(action: {
                                selectedLanguage = language
                                selectedFlag = flag
                                lm.changeLanguage(to: lang)
                                
                                isMenuOpen = false // Seçim yapıldığında popover'ı kapat
                            }) {
                                HStack {
                                    Text("\(flag) \(language)")
                                        .font(.custom("Poppins-Medium", size: 15))
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .padding(10)
                            }
                            Divider() // Her öğe arasına çizgi
                                .background(Color.black)
                        }
                    }
                }
                .frame(height: 150)
                .padding(.top, 130)

                 // Menüyü doğru pozisyona yerleştir
                .zIndex(1) // Menüyü diğer içeriklerin üzerine getir
            }
        }
        //.frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }

}

#Preview {
    LoginRegisterView()
}


/*
ZStack {
    CustomTextView(text: "Welcome to \nContraction \nTimer Plus", lineSpacing: -15)
        .font(.custom("DMSerifDisplay-Regular", size: 55))
        .foregroundColor(.white)
}
*/
