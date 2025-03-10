//
//  HomeView.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Environment(\.modelContext) private var modelContext
    @State private var pdfData: PDFWrapper?
    @State private var pdfData2: PDFWrapper?
    @ObservedObject private var constants = Constants.shared
    @ObservedObject private var storeManager = StoreManager.shared
    @ObservedObject private var admob = InterstitialAdManager.shared
    
    @EnvironmentObject var viewModel: MainViewModel
    @State private var scrollProxy: ScrollViewProxy?
    @State private var generalActive = false
    
    @State private var noPayment = false
    @State private var showingOptions = false
    @State private var sendMail = false
    var sortedPainLists: [PainIntensity] {
        Constants.shared.painLists.sorted(by: { $0.processNo > $1.processNo }) // Büyükten küçüğe sırala
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
                    Text("Contractions".localized + " \(viewModel.contractionCount)")
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
            //.padding(.horizontal, 20)
            
            HStack
            {
                Text("duration".localized)
                Spacer()
                Text("frequency".localized)
                
            }
            .font(.custom("Poppins-Medium", size: 13))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 25)
            .padding(.vertical, 5)
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(sortedPainLists, id: \.processNo) { pain in
                            PainItem(pain: pain)
                                .environmentObject(viewModel)
                                .id(pain.processNo)
                        }
                    }
                }
                .onAppear {
                    self.scrollProxy = proxy
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .padding(.horizontal, 15)

            
            GeneralButton2(isActive: generalActive)
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
                
                if let firstPain = sortedPainLists.first {
                    scrollProxy?.scrollTo(firstPain.processNo, anchor: .top)
                }
            }
            .padding(.top, 10)
            
            HStack {
                
                Button(action: {
                    //burada kişilere pdf dosyasını gönderiyoruz...
                    Task {
                        
                        viewModel.getMailList(modelContext: modelContext)
                        
                        if storeManager.isSubscriptionActive {
                            self.showingOptions = true
                        } else {
                            noPayment = true
                        }
                    }
                    
                }) {
                    HStack {
                        Image(systemName: "water.waves")
                            .foregroundColor(.black)
                        Text("Share_Contractions".localized)
                            .foregroundColor(.black)
                            .font(.custom("Poppins-Medium", size: 13))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(5)
                    .background(.grayf3)
                    .cornerRadius(10)
                }
                .actionSheet(isPresented: $showingOptions) {
                    ActionSheet(
                        title: Text("Select_an_action".localized),
                        buttons: [
                            .default(Text("send_mail".localized)) {
                                let headers = ["header_rap_no".localized,
                                               "header_rap_startdate".localized,
                                               "header_rap_stopdate".localized,
                                               "header_rap_duration".localized,
                                               "header_rap_paintinterval".localized,
                                               "header_rap_severityvalue".localized]
                                
                                
                                let repData = viewModel.getRapor()
                                let generatedPDF = PDFCreator(painData: repData,
                                                              title: "rap_title".localized,
                                                              subtitle: "rap_subtitle".localized,
                                                              reportDescription: "rap_desc".localized,
                                                              headers: headers).createPDF()
                                pdfData = PDFWrapper(data: generatedPDF)
                            },

                            .default(Text("get_report".localized)) {
                                
                                let headers = ["header_rap_no".localized,
                                               "header_rap_startdate".localized,
                                               "header_rap_stopdate".localized,
                                               "header_rap_duration".localized,
                                               "header_rap_paintinterval".localized,
                                               "header_rap_severityvalue".localized]
                                
                                
                                let repData = viewModel.getRapor()
                                let generatedPDF = PDFCreator(painData: repData,
                                                              title: "rap_title".localized,
                                                              subtitle: "rap_subtitle".localized,
                                                              reportDescription: "rap_desc".localized,
                                                              headers: headers).createPDF()
                                
                                pdfData2 = PDFWrapper(data: generatedPDF)
                            },
                        ]
                    )
                }
                
                Button(action: {
                    //burada acil kişilerini filtreleyip mail ve/veya mesaj yada göndereceğiz...
                    viewModel.getMailList(modelContext: modelContext)
                    Task {
                        if storeManager.isSubscriptionActive {
                            self.sendMail = true
                        } else {
                            noPayment = true
                        }
                    }
                    
                }) {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.white)
                        
                        Text("inform_people".localized)
                            .foregroundColor(.white)
                            .font(.custom("Poppins-Medium", size: 13))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(5)
                    .background(.darkgray)
                    .cornerRadius(10)
                }
                
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 10)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.all, 20)
        .onAppear
        {
            viewModel.getMailList(modelContext: modelContext)
        }
        .sheet(isPresented: $sendMail) {
            MailView(
                recipients: viewModel.emailList, // ✅ Hata düzeltildi: Artık dizi kabul ediyor
                subject: "help_mail_title".localized,
                body: "help_mail_desc".localized,
                attachmentData: nil,
                attachmentMimeType: nil,
                attachmentFileName: nil
                )
        }
        .sheet(item: $pdfData) { pdf in
            MailView(
                recipients: viewModel.emailList, // ✅ Hata düzeltildi: Artık dizi kabul ediyor
                subject: "rap_title".localized,
                body: "rap_subtitle".localized,
                attachmentData: pdf.data,
                attachmentMimeType: "application/pdf",
                attachmentFileName: "Report.pdf"
            )
        }
        .sheet(item: $pdfData2) { pdf in
            PdfActivityView(activityItems: [pdf.data])
        }
        .alert(isPresented: $noPayment) {
            Alert(title: Text("Subscription_Control".localized),
                  message:
                    Text("membership_not_act_desc".localized),
                  dismissButton: .default(Text("Ok".localized)))
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
        .onAppear {
            
            if storeManager.isSubscriptionActive == false {
                admob.showInterstitialAd()
            }
        }
        //bura ödeme yoksa çalışacak şekilde düzenleyeceğiz...
        //DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            //admob.showInterstitialAd()
        //}
    }
}


#Preview {
    HomeView().environmentObject(MainViewModel())
}
