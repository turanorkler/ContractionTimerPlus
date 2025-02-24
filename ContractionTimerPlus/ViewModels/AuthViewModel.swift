//
//  FirebaseSinginViewModel.swift
//  ContractionTimerPlus
//
//  Created by ismail örkler on 25.02.2025.
//

import AuthenticationServices
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class AuthViewModel: NSObject, ObservableObject {
    
    static let shared = AuthViewModel()
    
    @Published var isLoggedIn: Bool = false
    @Published var user: User? = nil
    @Published var fullName: String = UserDefaults.standard.string(forKey: "fullName") ?? ""
    @Published var email: String = UserDefaults.standard.string(forKey: "email") ?? ""
    private var currentNonce: String?

    override init() {
        super.init()
        checkIfUserIsSignedIn()
    }

    /// Kullanıcı oturum açmış mı kontrol et
    func checkIfUserIsSignedIn() {
        if let currentUser = Auth.auth().currentUser {
            self.isLoggedIn = true
            self.user = currentUser
            self.email = UserDefaults.standard.string(forKey: "email") ?? ""
            self.fullName = UserDefaults.standard.string(forKey: "fullName") ?? ""
            print("✅ Kullanıcı oturum açık: \(currentUser.uid)")
        } else {
            self.isLoggedIn = false
            self.user = nil
            self.fullName = "Bilinmiyor"
            self.email = "Bilinmiyor"
        }
    }

    /// Apple ile giriş yapma işlemini başlat
    func startSignInWithApple() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let hashedNonce = sha256(nonce)

        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = hashedNonce

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    /// Google ile giriş yap
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("❌ Google Client ID bulunamadı")
            return
        }

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("❌ RootViewController bulunamadı")
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                print("❌ Google Girişi Hatası: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("❌ Google ID Token alınamadı")
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("❌ Firebase Google Girişi Hatası: \(error.localizedDescription)")
                    return
                }

                DispatchQueue.main.async {
                    self.isLoggedIn = true
                    self.user = authResult?.user
                    self.email = authResult?.user.email ?? "E-posta yok"
                    
                    // Kullanıcı bilgilerini kaydet
                    UserDefaults.standard.setValue(self.email, forKey: "email")
                    UserDefaults.standard.synchronize()

                    print("✅ Google ile Firebase'e giriş başarılı: \(self.user?.uid ?? "Bilinmiyor")")
                }
            }
        }
    }

    /// E-Posta ve Şifre ile giriş yap
    func signInWithEmail(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("❌ E-Posta Girişi Hatası: \(error.localizedDescription)")
                return
            }

            DispatchQueue.main.async {
                self.isLoggedIn = true
                self.user = authResult?.user
                self.email = email
                
                // Kullanıcı bilgilerini kaydet
                UserDefaults.standard.setValue(email, forKey: "email")
                UserDefaults.standard.synchronize()

                print("✅ E-Posta ile Firebase'e giriş başarılı: \(self.user?.uid ?? "Bilinmiyor")")
            }
        }
    }

    /// Kullanıcı çıkış yaparsa oturumu kapat
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
            self.user = nil
            self.fullName = ""
            self.email = ""
            
            // Hafızadan kullanıcı bilgilerini sil
            UserDefaults.standard.removeObject(forKey: "fullName")
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.synchronize()

            print("✅ Kullanıcı çıkış yaptı ve bilgiler silindi.")
        } catch {
            print("❌ Çıkış yaparken hata: \(error.localizedDescription)")
        }
    }
}

extension AuthViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("❌ Apple Kimlik doğrulaması başarısız oldu.")
            return
        }
        
        guard let identityToken = appleIDCredential.identityToken,
              let tokenString = String(data: identityToken, encoding: .utf8),
              let nonce = currentNonce else {
            print("❌ Token veya nonce alınamadı.")
            return
        }
        
        // ✅ **Apple Credential'ı güncel Firebase yöntemiyle oluşturuyoruz**
        let credential = OAuthProvider.credential(providerID: .apple, idToken: tokenString, rawNonce: nonce)

        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print("❌ Firebase Apple Girişi Hatası: \(error.localizedDescription)")
                return
            }

            guard let user = authResult?.user else {
                print("❌ Kullanıcı bilgisi alınamadı.")
                return
            }

            DispatchQueue.main.async {
                self.isLoggedIn = true
                self.user = user
                self.email = user.email ?? "E-posta yok"
                
                // Kullanıcı bilgilerini kaydet
                UserDefaults.standard.setValue(self.email, forKey: "email")
                UserDefaults.standard.synchronize()

                print("✅ Apple ile Firebase'e giriş başarılı: \(self.user?.uid ?? "uid yok")")
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("❌ Apple Giriş Hatası: \(error.localizedDescription)")
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return UIWindow()
        }
        return window
    }
}
