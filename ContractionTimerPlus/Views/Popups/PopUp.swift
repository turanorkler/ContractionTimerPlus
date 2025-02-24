//
//  PopUp.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 22.02.2025.
//

import SwiftUI

struct PopUp: View {
    let icon: String?
    let title : String
    let description : String
    let subDescription : String
    let action : () -> Void
    
    @ObservedObject var constants = Constants.shared
    
    var body: some View {
        ZStack {
            
            Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)
            
            VStack {
                
                HStack {
                    Button(action : {
                        constants.popUpCover = nil
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                
                Spacer()
                
                VStack {
                    
                    if let icon = icon, !icon.isEmpty {
                        Image(icon)
                            .resizable()
                            .fixedSize()
                    }
                    
                    Text(title.localized)
                        .font(.custom("Poppins-Medium", size: 25))
                        .bold()
                        .foregroundColor(.greenradial)
                    
                    Text(description.localized)
                        .font(.custom("Poppins-Medium", size: 14))
                        .multilineTextAlignment(.center)


                }
                .padding(20)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(.white)
                .cornerRadius(20)
                
                Text(subDescription.localized)
                    .font(.custom("Poppins-Medium", size: 14))
                    .multilineTextAlignment(.center)
                    .padding(.top, 30)
                    .foregroundColor(.white)

                Spacer()
                
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        
    }
}

#Preview {
    PopUp(icon: "baby", title: "Get Ready",
          description:  "We recommend that you get ready to go to the hospital. Now, you can check whether you packed all the things and documents. Time allows you to take a shower and have a light meal. Continue timing contractions. If the hospital is far away or this is not your first baby, you may be better off going to the hospital right now. In addition, we recommend that you consult you doctor.",
          subDescription: "Average duration of contractions as 1 minute 10 seconds, average frequency is 8 minutes 24 seconds correspond to the initial phase of the first stage of labor."
    )
    {
        
    }
}
