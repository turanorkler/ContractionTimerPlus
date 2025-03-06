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
            HStack(alignment: .bottom, spacing: 15)
            {
                Text(pain.processStartTime.formatted(date: .omitted, time: .shortened))
                    .font(.custom("Poppins-Medium", size: 19))
                    .foregroundColor(.d9)
                    .frame(width: 50, alignment: .leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: true, vertical: false)
                
                Text(formattedTimeDifference())
                    .font(.custom("Poppins-Medium", size: 22))
                    .foregroundColor(.black)
                    .frame(width: 60, alignment: .leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    //.background(.gray)
                    //.tracking(-0.5)
                
                ZStack {
                   
                    
                    
                    if !isLastInserted() {
                        Rectangle()
                            .fill(Color.orange) // Arka plan için opsiyonel renk
                            .frame(minWidth: 10, maxWidth: 10, maxHeight: .infinity)
                            .offset(y: -5)
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
                    
                    /*
                    //Circlenin üzerine process no yazar...
                    Text(String("\(pain.processNo)"))
                        .font(.custom("Poppins-Medium", size: 16)  )
                        .foregroundColor(.black)
                     */
                }
                .frame(height: 70)
                
                VStack(spacing: 0) {
                    
                    Text(formattedCurrentTime())
                        .font(.custom("Poppins-Medium", size: 22))
                        .fontWeight(Font.Weight.medium)
                        .foregroundColor(.black)
                        .lineLimit(0)
                        .frame(width: 90, alignment: .leading)
                    
                    IntensityItem(intensity: pain.painIntensity ?? 0)
                        .padding(.bottom, 20)
                        
                }
            }
            .frame(maxWidth: .infinity)
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
        guard pain.processEndTime != nil else {
            return "0:00"
        }
        
        let sortedPainLists = viewModel.painLists.sorted { $0.processNo < $1.processNo }
        
        // Kendinden bir büyük olan `processNo` değerine sahip kaydı bul
        let nextItem = sortedPainLists.first(where: { $0.processNo > pain.processNo })
        
        // Eğer kendinden büyük bir kayıt varsa onun `processStartTime` değerini al,
        // yoksa (son kayıt ise) `Date()` kullan.
        //let timer = nextItem?.processStartTime ?? Date()
        
        //let interval = timer.timeIntervalSince(pain.processStartTime)

        let timer = nextItem?.processEndTime ?? Date()
        let interval = timer.timeIntervalSince(pain.processEndTime ?? Date())
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
   
