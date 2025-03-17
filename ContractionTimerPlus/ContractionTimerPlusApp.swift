//
//  ContractionTimerPlusApp.swift
//  ContractionTimerPlus
//
//  Created by ismail örkler on 24.02.2025.
//

import SwiftUI
import FirebaseCore
import SwiftData

@main
struct ContractionTimerPlusApp: App {
    
    init() {
        Task {
            await AppState.shared.initialize()
        }
    }
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @AppStorage("appFirstRun") private var appFirstRun: Bool = false
    @ObservedObject var constants = Constants.shared
    @ObservedObject var lm = LanguageManager.shared
    @ObservedObject  var storeManager = StoreManager.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if !appFirstRun {
                    OnboardingView()
                } else {
                    MainView()
                }
            }
            .overlay(
                Group {
                    if constants.popUpCover == .getReady
                    {
                        PopUp(icon: "baby", title: "Get_Ready".localized,
                              description:  "Get_Ready_Desc".localized,
                              subDescription: "Get_Ready_SubDesc".localized
                        )
                        {
                            constants.popUpCover = nil
                        }
                    }
                    if constants.popUpCover == .gotoHospital {
                        PopUp(icon: "hospital", title: "Go_Hospital".localized,
                              description:  "Go_Hospital_Desc".localized,
                              subDescription: "Go_Hospital_SubDesc".localized
                        )
                        {
                            constants.popUpCover = nil
                        }
                    }
                    if constants.popUpCover == .info {
                        PopUpAttention(icon: "attention", title: "Go_Hospital".localized)
                        {
                            constants.popUpCover = nil
                        }
                    }
                }
            )
            //fullscreen popuplar burada olacak...
            .fullScreenCover(item: $constants.fullScreenCover) { popup in
                
                if popup == .paywall1
                {
                    Paywall1View()
                } else if popup == .paywall2
                {
                    Paywall2View()
                } else if popup == .paywall3
                {
                    Paywall3View()
                } else if popup == .pdfFile
                {
                    PDFViewer(pdfName: "who")
                }
            }
            .modelContainer(for: [Contact.self, PainIntensity.self], inMemory: false)
            
        }
    }
}
