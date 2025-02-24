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
                    Text("Last -".localized)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Contractions -".localized)
                        .lineLimit(nil)
                        .fixedSize(horizontal: true, vertical: true)
                }
                .font(.custom("Poppins-Medium", size: 12))
                .foregroundColor(.black)
                
                Spacer()
                
                VStack(spacing: 5) {
                    Text("0:00")
                        .lineLimit(nil)
                        .fixedSize(horizontal: true, vertical: true)
                        .foregroundColor(.black)
                    Text("avg. \nduration".localized)
                        .lineLimit(nil)
                        .fixedSize(horizontal: true, vertical: true)
                        
                        .multilineTextAlignment(.center)
                }
                .font(.custom("Poppins-Medium", size: 12))
                .foregroundColor(.black)
                .frame(alignment: .center)
                
                Spacer()
                
                VStack(spacing: 5) {
                    Text("0:00")
                        .lineLimit(nil)
                        .fixedSize(horizontal: true, vertical: true)
                    Text("avg. \nfrequency")
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
        
            //Spacer()
            /*
            ScrollView {
                //veriler buraya listelenecek
                List(viewModel.painLists, id: \.self) { pain in
                    
                    HStack {
                        Text("No: \(pain.processNo)")
                        Spacer()
                        Text(viewModel.timeDifference(for: pain)) // Süreyi göster
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                    }
                    //ContactRow(contact: contact)
                        //.environmentObject(viewModel)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            //.background(.gray)
            */
            
            
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
                    /*
                    .onChange(of: viewModel.painLists.count) {
                        // Yeni kayıt eklenince en başa kaydır
                        if let index = viewModel.painLists.indices.first {
                            withAnimation {
                                scrollProxy?.scrollTo(index, anchor: .top)
                            }
                        }
                    }
                     */
                }
                .onAppear {
                    self.scrollProxy = proxy // Proxy'yi kaydediyoruz
                    
                    /*if let firstPain = sortedPainLists.first {
                        withAnimation {
                            proxy.scrollTo(firstPain.processNo, anchor: .top)
                        }
                    }*/
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
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    /*if let firstPain = sortedPainLists.first { // En büyük processNo'ya sahip elemanı al
                        withAnimation {
                            scrollProxy?.scrollTo(firstPain.processNo, anchor: .top)
                        }
                    }*/
                }
                
            }
            
            //alt buttonlar burada
            HStack {
                
                Button(action: {
                    viewModel.loadPaingList(modelContext: modelContext)
                }) {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.black)
                        Text("Share Contractions".localized)
                            .foregroundColor(.black)
                            .font(.custom("Poppins-Medium", size: 13))
                    }
                    .padding(10)
                    .background(.sharecontraction.opacity(0.2))
                    .cornerRadius(10)
                }
                
                Button(action: {
                    //viewModel.loadPaingList2(modelContext: modelContext)
                    let generatedPDF = PDFCreator(painData: viewModel.painLists).createPDF()
                    pdfData = PDFWrapper(data: generatedPDF)
                }) {
                    HStack {
                        Image(systemName: "light.beacon.max")
                            .foregroundColor(.white)
                        
                        Text("Emergency Texts".localized)
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
                    Pain(title: "Add Contractions")
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
