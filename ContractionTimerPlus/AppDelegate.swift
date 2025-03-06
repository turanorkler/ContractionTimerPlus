//
//  AppDelegate.swift
//  ContactionTimer
//
//  Created by ismail örkler on 23.02.2025.
//

import UIKit
import GoogleMobileAds
import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error = error {
                print("❌ Bildirim izni alınırken hata: \(error.localizedDescription)")
            } else {
                print("✅ Bildirim izni verildi: \(granted)")
            }
        }
        application.registerForRemoteNotifications()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            Messaging.messaging().token { token, error in
                if let error = error {
                    print("❌ Firebase Token alınamadı: \(error.localizedDescription)")
                } else if let token = token {
                    print("✅ Firebase Token Manuel Alındı: \(token)")
                }
            }
        }
        
        MobileAds.shared.start { status in
            print("Google Mobile Ads SDK Başlatıldı: \(status.adapterStatusesByClassName)")
        }
        
        return true
    }
    
    //bu method olmazsa uygulama kapalıyken bildirim alamıyor...
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("📢 Foreground'da bildirim alındı!")

        if let imageUrl = notification.request.content.userInfo["image"] as? String {
            print("📷 Bildirimde resim var: \(imageUrl)")
            
            // Resmi indir ve göster
            downloadImage(from: imageUrl) { localURL in
                if let localURL = localURL {
                    let attachment = try? UNNotificationAttachment(identifier: UUID().uuidString, url: localURL, options: nil)
                    if let attachment = attachment {
                        let newContent = notification.request.content.mutableCopy() as! UNMutableNotificationContent
                        newContent.attachments = [attachment]
                        
                        let request = UNNotificationRequest(identifier: notification.request.identifier, content: newContent, trigger: nil)
                        UNUserNotificationCenter.current().add(request)
                    }
                }
            }
        }
        
        completionHandler([.banner, .sound, .badge])
    }

    // Resmi indir ve local cache'e kaydet
    func downloadImage(from urlString: String, completion: @escaping (URL?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let tempUrl = FileManager.default.temporaryDirectory.appendingPathComponent("image.jpg") as URL? else {
                completion(nil)
                return
            }
            do {
                try data.write(to: tempUrl)
                completion(tempUrl)
            } catch {
                completion(nil)
            }
        }.resume()
    }


    func application(_ application: UIApplication,
                         didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("✅ APNs Token Alındı: \(tokenString)")

        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")
    }

    
    /*func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()

        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self  // <-- Bunu eklemelisin!

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()

        MobileAds.shared.start { status in
            print("Google Mobile Ads SDK Başlatıldı: \(status.adapterStatusesByClassName)")
        }
        
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")
    }*/
}

