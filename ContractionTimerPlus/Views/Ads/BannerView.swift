//
//  GADManagerBannerViewController.swift
//  ContactionTimer
//
//  Created by ismail örkler on 23.02.2025.
//

import SwiftUI
import GoogleMobileAds

struct BannerView: UIViewControllerRepresentable {
    
    @State private var constants = Constants.shared
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let bannerView = AdManagerBannerView(adSize: AdSizeBanner) // Google Ad Manager Banner View
        bannerView.adUnitID = constants.getBannerAdsID()
        bannerView.rootViewController = viewController
        bannerView.load(AdManagerRequest())

        viewController.view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            bannerView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        ])

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
