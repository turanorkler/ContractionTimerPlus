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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var constants = Constants.shared
    @ObservedObject var lm = LanguageManager.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                OnboardingView()
            }
            .overlay(
                Group {
                    if constants.popUpCover == .getReady
                    {
                        PopUp(icon: "baby", title: "Get Ready",
                              description:  "We recommend that you get ready to go to the hospital. Now, you can check whether you packed all the things and documents. Time allows you to take a shower and have a light meal. Continue timing contractions. If the hospital is far away or this is not your first baby, you may be better off going to the hospital right now. In addition, we recommend that you consult you doctor.",
                              subDescription: "Average duration of contractions as 1 minute 10 seconds, average frequency is 8 minutes 24 seconds correspond to the initial phase of the first stage of labor."
                        )
                        {
                            constants.popUpCover = nil
                        }
                    }
                    if constants.popUpCover == .gotoHospital {
                        PopUp(icon: "hospital", title: "Go to the hospital",
                              description:  "Call an ambulance or use other transportation and make sure to bring the items and documents you will need during your hospital stay. In addition, we recommend that you consult you doctor.",
                              subDescription: "Average duration of contractions 42 seconds, average frequency is 5 minutes 2 seconds correspond to the activve phase of the labor."
                        )
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
                }
            }
            .modelContainer(for: [Contact.self, PainIntensity.self], inMemory: false)
            
        }
    }
}
