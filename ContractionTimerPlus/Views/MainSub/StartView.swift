//
//  HomeView.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//

import SwiftUI

struct StartView: View {
    
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        
        VStack(spacing: 0)
        {
            Image(systemName: "exclamationmark.shield.fill")
                .resizable()
                .frame(width: 85, height: 110)
                .foregroundColor(.alarmred)
                .padding(.top, 40)
            
            
            Text("If_your_water".localized)
                .font(.custom("Poppins-Light", size: 15))
                .foregroundColor(.alarmred)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.alarmred.opacity(0.2))
                .cornerRadius(15)
                .padding(.top, 20)
            
            Text("Time_several_contractions".localized)
                .font(.custom("Poppins-Light", size: 15))
                .foregroundColor(.warninggreen)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .padding(.top, 100)
            
            Button(action : {
                viewModel.changeScreen(.home)
            }) {
                Text("Start".localized)
                    .padding(10)
                    .font(.custom("Poppins-Medium", size: 17))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.top, 20)
            }
        
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 20)
    }
}
