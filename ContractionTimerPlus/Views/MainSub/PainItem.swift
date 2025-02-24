//
//  PainItem.swift
//  ContactionTimer
//
//  Created by ismail örkler on 24.02.2025.
//

import SwiftUI

struct PainItem : View {
    
    @EnvironmentObject private var viewModel : MainViewModel
    
    @Bindable var pain: PainIntensity
    @State private var currentTime = Date()
    
    var body: some View {
        ZStack
        {
            HStack(alignment: .bottom, spacing: 30)
            {
                /*
                Text("\(pain.processNo)")
                    .font(.custom("Poppins-Medium", size: 16))
                    .foregroundColor(.black)
                */
                Text(pain.processStartTime.formatted(date: .omitted, time: .shortened))
                    .font(.custom("Poppins-Medium", size: 16))
                    .foregroundColor(.d9)
                    .frame(width: 40, alignment: .leading)
                    .lineLimit(0)
                
                Text(formattedTimeDifference())
                    .font(.custom("Poppins-Medium", size: 22))
                    .foregroundColor(.black)
                    .lineLimit(0)
                    .frame(width: 60, alignment: .leading)
                    .lineLimit(0)
                    //.background(.gray)
                    //.tracking(-0.5)
                
                ZStack {
                   
                    Text("\(pain.processNo)")
                        .font(.custom("Poppins-Medium", size: 16)  )
                        .foregroundColor(.black)
                    
                    if !isLastInserted() {
                        Rectangle()
                            .fill(Color.orange) // Arka plan için opsiyonel renk
                            .frame(minWidth: 10, maxWidth: 10, maxHeight: .infinity)
                            .offset(y: -10)
                    }
                    
                    Circle()
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [Color.splashcolor1, Color.d9]),
                                           startPoint: .top,
                                           endPoint: .bottomTrailing)
                        )
                        .frame(width: 60, height: 60)
                        .overlay(
                            
                                Circle()
                                    .stroke(isLastInserted() ? Color.orange : Color.clear, lineWidth: 5)
                                    .padding(1) // Kenarlığı içeriye almak için
                            )
                }
                .frame(height: 70)
                
                VStack(spacing: 0) {
                    Text(formattedCurrentTime())
                        .font(.custom("Poppins-Medium", size: 22))
                        .fontWeight(Font.Weight.medium)
                        .foregroundColor(.black)
                        .lineLimit(0)
                        .frame(width: 70, alignment: .leading)
                    
                    IntensityItem(intensity: pain.painIntensity ?? 0)
                        .padding(.bottom, 20)
                        
                }
            }
            .frame(maxWidth: .infinity)
            .padding(0)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.currentTime = Date()
            }
        }
    }
    
    private func isLastInserted() -> Bool {
        let pro = viewModel.painLists.max(by: { $0.processNo < $1.processNo })
        let processno = pro?.processNo == pain.processNo
        return processno
    }
    

    private func formattedTimeDifference() -> String {
        let endTime = pain.processEndTime ?? Date()
        let interval = endTime.timeIntervalSince(pain.processStartTime)
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%2d:%02d", minutes, seconds)
   }
    
    private func formattedCurrentTime() -> String {
        if pain.processEndTime == nil {
            return String("0:00")
        }
    
        var timer = Date()
        if let nextItem = viewModel.painLists.first(where: { $0.processNo > pain.processNo }) {
            timer = nextItem.processStartTime
        }
        let interval = timer.timeIntervalSince(pain.processStartTime)
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%2d:%02d", minutes, seconds)
    }
}

#Preview
{
    VStack(spacing:5) {
        PainItem(pain: PainIntensity(
            processStartTime: Date(),
            processEndTime: nil,
            painIntensity: nil)).environmentObject(MainViewModel())

    }
}
   
