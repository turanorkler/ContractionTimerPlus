//
//  HomeView.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.modelContext) private var modelContext
    @State private var pdfData: PDFWrapper?
    @ObservedObject var constants = Constants.shared
    @EnvironmentObject var viewModel: MainViewModel
    @State private var scrollProxy: ScrollViewProxy?
    @State var generalActive = false
    
    var sortedPainLists: [PainIntensity] {
        viewModel.painLists.sorted(by: { $0.processNo > $1.processNo }) // Büyükten küçüğe sırala
    }
    
    var body: some View {
        
        VStack(spacing: 0)
        {
            HStack(spacing: 10)
            {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Last".localized + " \(viewModel.lastPainDate)")
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Contractions ".localized + " \(viewModel.contractionCount)")
                        .lineLimit(nil)
                        .fixedSize(horizontal: true, vertical: true)
                }
                .font(.custom("Poppins-Medium", size: 12))
                .foregroundColor(.black)
                
                Spacer()
                
                VStack(spacing: 5) {
                    Text(viewModel.avgDuration)
                        .lineLimit(nil)
                        .fixedSize(horizontal: true, vertical: true)
                        .foregroundColor(.black)
                    Text("avg_duration".localized)
                        .lineLimit(nil)
                        .fixedSize(horizontal: true, vertical: true)
                        
                        .multilineTextAlignment(.center)
                }
                .font(.custom("Poppins-Medium", size: 12))
                .foregroundColor(.black)
                .frame(alignment: .center)
                
                Spacer()
                
                VStack(spacing: 5) {
                    Text(viewModel.avgFrequency)
                        .lineLimit(nil)
                        .fixedSize(horizontal: true, vertical: true)
                    Text("avg_frequency".localized)
                        .lineLimit(nil)
                        .fixedSize(horizontal: true, vertical: true)
                        .multilineTextAlignment(.center)
                }
                .font(.custom("Poppins-Medium", size: 12))
                .foregroundColor(.black)
                .frame(alignment: .center)

                
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.headerbg)
            .cornerRadius(15)
            .padding(.horizontal, 35)
            
            HStack
            {
                Text("Duration".localized)
                Spacer()
                Text("Frequency".localized)
                
            }
            .font(.custom("Poppins-Medium", size: 13))
            .foregroundColor(.black)
            .padding()
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 35)
        
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 5) {
                        //ForEach(viewModel.painLists.indices, id: \.self) { index in
                        //ForEach(sortedPainLists, id: \.self) { index in
                        ForEach(sortedPainLists, id: \.processNo) { pain in
                            PainItem(pain: pain)
                                .environmentObject(viewModel)
                                .id(pain.processNo) // ID ekleyerek kaydırma işlemini yapacağız
                        }
                    }
                }
                .onAppear {
                    self.scrollProxy = proxy
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .padding()

            
            GeneralButton(isActive: generalActive)
            {
                if generalActive {
                    generalActive = false
                    viewModel.lastInsertedProcess?.processEndTime = Date()
                    //viewModel.updateProcess(modelContext: modelContext, newEndTime: Date(), newPainIntensity: nil)
                    constants.popUpCover = .addContractions
                } else {
                    generalActive = true
                    viewModel.addProcess(modelContext: modelContext)
                }
                
            }
            
            HStack {
                
                Button(action: {
                    viewModel.loadPaingList(modelContext: modelContext)
                }) {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.black)
                        Text("Share_Contractions".localized)
                            .foregroundColor(.black)
                            .font(.custom("Poppins-Medium", size: 13))
                    }
                    .padding(10)
                    .background(.sharecontraction.opacity(0.2))
                    .cornerRadius(10)
                }
                
                Button(action: {
                    //viewModel.loadPaingList2(modelContext: modelContext)
                    let repData = viewModel.getRapor()
                    let generatedPDF = PDFCreator(painData: repData, title: "aaaa", subtitle: "bbb").createPDF()
                    pdfData = PDFWrapper(data: generatedPDF)
                    
                }) {
                    HStack {
                        Image(systemName: "light.beacon.max")
                            .foregroundColor(.white)
                        
                        Text("Emergency_Texts".localized)
                            .foregroundColor(.white)
                            .font(.custom("Poppins-Medium", size: 13))
                    }
                    .padding(10)
                    .background(.alarmred)
                    .cornerRadius(10)
                }
            }
            .padding(.top, 30)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.all, 20)
        .sheet(item: $pdfData) { pdf in
            PdfActivityView(activityItems: [pdf.data]) // İçindeki `Data`'yı alıyoruz
        }
        .overlay {
            Group {
                if constants.popUpCover == .addContractions
                {
                    Pain(title: "Add_Contractions".localized)
                    { intensity in
                        
                        viewModel.updateProcess(modelContext: modelContext, newPainIntensity: intensity)
                        
                        constants.popUpCover = nil
                        
                    }
                }
            }
        }
    }
}


#Preview {
    HomeView().environmentObject(MainViewModel())
}
