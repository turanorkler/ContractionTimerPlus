//
//  PopUp.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 22.02.2025.
//

import SwiftUI

struct PopUpAttention: View {
    let icon: String?
    let title : String
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
                    
                    Text("info_title".localized)
                        .font(.custom("Poppins-Medium", size: 25))
                        .bold()
                        .foregroundColor(.alarmred)
                    
                    
                    AppComment(fontSize:  15)

                }
                .padding(20)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(.white)
                .cornerRadius(20)
                

                Spacer()
                
                
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        
    }
}

#Preview {
    PopUpAttention(icon: "attention", title: "Get Ready")
    {
        
    }
}
