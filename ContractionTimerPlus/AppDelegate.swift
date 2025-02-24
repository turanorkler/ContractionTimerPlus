//
//  AppDelegate.swift
//  ContactionTimer
//
//  Created by ismail örkler on 23.02.2025.
//

import UIKit
import FirebaseCore
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        
        MobileAds.shared.start { status in
            print("Google Mobile Ads SDK Başlatıldı: \(status.adapterStatusesByClassName)")
        }
        //GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
}
