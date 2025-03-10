//
//  MainViewModel.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 21.02.2025.
//

import Combine
import SwiftUI
import SwiftData

class MainViewModel: ObservableObject {
    
    //@Published var painLists: [PainIntensity] = []
    @Published var lastInsertedProcess: PainIntensity?
    
    @Published var screen : Screens = .start
    @Published var isLoading = false
    
    @Published var isError: Bool = false
    
    @Published var lastPainDate = "-"
    @Published var contractionCount = 0
    @Published var avgDuration = "0:00"
    @Published var avgFrequency = "0:00"
    
    @Published var emailList: [String] = []
    
    private var timer: Timer?
    
    init() {
        startTimer()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            DispatchQueue.main.async {
                //self.objectWillChange.send() // UI güncellenmesini tetikle
                self.getReportData()
                let pain = Constants.shared.painLists.max(by: { $0.processNo < $1.processNo })
                self.lastPainDate = self.formatDuration(Date().timeIntervalSince(pain?.processStartTime ?? Date()))
                self.contractionCount = Constants.shared.painLists.count
            }
        }
    }
    
    func addProcess(modelContext: ModelContext) {
        
        let newProcessNo = (Constants.shared.painLists.max(by: { $0.processNo < $1.processNo })?.processNo ?? 0) + 1

        let newProcess = PainIntensity(
            //processNo: self.painLists.count == 0 ? 1 : self.painLists.last!.processNo + 1,
            processNo: newProcessNo,
            processStartTime: Date(),
            processEndTime: nil,
            painIntensity: nil
        )
        
        DispatchQueue.main.async {
            self.lastInsertedProcess = newProcess
            Constants.shared.painLists.append(newProcess) // Sadece listeye ekle, veritabanına kaydetme
            print("\(newProcess.processNo) Eklendi \(Constants.shared.painLists.count)")
        }
    }

    
    func updateProcess(modelContext: ModelContext, newPainIntensity: Int) {
        Task {
            lastInsertedProcess?.painIntensity = newPainIntensity
            do {
                if lastInsertedProcess != nil {
                    
                    
                    modelContext.insert(lastInsertedProcess!)
                    try modelContext.save()
                    
                    DispatchQueue.main.async {
                        
                    }
                    
                    let averageFrequency = alarm(hour: -1)
                    
                    if averageFrequency == 0.5 {
                        DispatchQueue.main.async {
                            Constants.shared.popUpCover = .getReady
                        }
                    } else if averageFrequency == 1.0 {
                        DispatchQueue.main.async {
                            Constants.shared.popUpCover = .gotoHospital
                        }
                    }
                    
                    print("✅ Kayıt başarıyla güncellendi: \(String(describing: lastInsertedProcess?.painIntensity))")
                }
            } catch {
                print("❌ Veritabanına kaydetme hatası: \(error.localizedDescription)")
            }

            print("🔍 Güncellenen Kayıt Sonrası -> processNo: \(String(describing: lastInsertedProcess?.processNo)), painIntensity: \(String(describing: lastInsertedProcess?.painIntensity))")
        }
    }
    
    func alarm(hour: Int = -1) -> Double {
        let lastHour = Calendar.current.date(byAdding: .hour, value: hour, to: Date())!

        // 1. Son X saatteki geçerli sancıları filtrele
        let filteredPainLists = Constants.shared.painLists.compactMap { process -> PainIntensity? in
            guard let intensity = process.painIntensity,
                  (1...5).contains(intensity),
                  let endTime = process.processEndTime,
                  process.processStartTime >= lastHour,
                  endTime > process.processStartTime
            else { return nil }
            return process
        }.sorted { $0.processStartTime < $1.processStartTime }

        // 2. Yeterli veri kontrolü
        guard filteredPainLists.count >= 3 else {
            print("⚠️ Yetersiz veri: En az 3 tam sancı gerekli")
            return 0.0
        }
        
        // 3. Sancı özelliklerini analiz et
        let minDuration: TimeInterval = 60.0 // 1 dakika (saniye)
        //let requiredIntensityIncrease = 2

        // Son 3 sancının özellikleri
        let lastThree = Array(filteredPainLists.suffix(3))
        let durations = lastThree.map { $0.processEndTime!.timeIntervalSince($0.processStartTime) }
        let intensities = lastThree.map { $0.painIntensity! }
        
        // Tüm sancıların minimum süreyi sağlaması
        guard durations.allSatisfy({ $0 >= minDuration }) else {
            print("⏱️ Sancı süresi yetersiz")
            return 0.0
        }

        // 4. Sıklık ve şiddet analizi
        let intervals = (1..<lastThree.count).map {
            lastThree[$0].processStartTime.timeIntervalSince(lastThree[$0-1].processStartTime)
        }
        
        let frequencyThresholds = (
            high: TimeInterval(5 * 60),    // 5 dk (saniye)
            medium: TimeInterval(10 * 60)  // 10 dk
        )

        // Yüksek risk: Sıklık ve şiddet artışı
        if intervals.allSatisfy({ $0 <= frequencyThresholds.high }) &&
           intensities.isStrictlyIncreasing() {
            print("🚨 ACİL: Düzenli ve şiddetlenen sancılar! Hemen hastaneye gidin.")
            return 1.0
        }
        // Orta risk: Sıklık artıyor veya şiddetlenme var
        else if (intervals.last ?? 0) <= frequencyThresholds.high ||
                intensities.isNonDecreasing() {
            print("⚠️ UYARI: Sancılar gelişiyor. Yakın takip gerekli.")
            return 0.5
        }
        // Düşük risk
        else {
            print("✅ NORMAL: Sancılar henüz kriterleri karşılamıyor.")
            return 0.0
        }
    }
    /*
    func alarm(hour: Int = -2) -> Double {
        let lastHour = Calendar.current.date(byAdding: .hour, value: hour, to: Date())!

        // 1. Son X saat içindeki sancıları filtrele (bitmiş ve şiddeti 1-5 arası olanlar)
        let filteredPainLists = painLists.filter { process in
            if let endTime = process.processEndTime,
               let intensity = process.painIntensity, // Nil kontrolü
               intensity >= 1, intensity <= 5 { // Şiddet 1 ile 5 arasında olmalı
                return endTime >= lastHour
            }
            return false
        }.sorted { $0.processStartTime < $1.processStartTime } // İşlemleri zamana göre sırala

        var totalFrequency: TimeInterval = 0
        var frequencyCount: Int = 0

        // 2. Sancı sıklığını hesapla
        for index in 1..<filteredPainLists.count {
            let currentItem = filteredPainLists[index]
            let previousItem = filteredPainLists[index - 1]

            if let prevEndTime = previousItem.processEndTime { // processEndTime nil kontrolü
                let frequency = currentItem.processStartTime.timeIntervalSince(prevEndTime)

                if frequency > 0 { // Negatif değerleri hariç tut
                    totalFrequency += frequency
                    frequencyCount += 1
                }
            }
        }

        let averageFrequency = frequencyCount > 0 ? totalFrequency / Double(frequencyCount) : 0
        let averageFrequencyInMinutes = averageFrequency / 60 // Saniyeyi dakikaya çevir

        print("Son \(abs(hour)) saat içindeki işlemlerin ortalama frekansı (dakika): \(Int(averageFrequencyInMinutes))")

        // 3. Risk değerlendirmesi ve alarm durumu
        if averageFrequencyInMinutes <= 5 {
            print("🚨 ACİL: Doğum başlıyor olabilir! Hemen doktora gidin!")
            return 1.0 // Yüksek risk
        } else if averageFrequencyInMinutes <= 10 {
            print("⚠️ Dikkat: Doğum yaklaşıyor, hastaneye hazırlanın.")
            return 0.5 // Orta risk
        } else {
            print("✅ Normal: Henüz doğum sancıları düzenli değil.")
            return 0.0 // Düşük risk
        }
    }
     */
    
    func loadPaingList(modelContext: ModelContext) {
        Task {
            do {
                let descriptor = FetchDescriptor<PainIntensity>(
                    sortBy: [SortDescriptor(\.processNo, order: .reverse)] // Büyükten küçüğe sıralama
                )
                let results = try modelContext.fetch(descriptor)
                
                print("✅ Çekilen kayıtlar: \(results.count)")
                for record in results {
                    print("📌 processNo: \(record.processNo), StartTime: \(record.processStartTime), EndTime: \(record.processEndTime!)")
                    
                }

                DispatchQueue.main.async {
                    Constants.shared.painLists = results
                }
            } catch {
                print("❌ Veri çekme hatası: \(error.localizedDescription)")
            }
        }
    }
    
    func formatDuration(_ timeInterval: TimeInterval?) -> String {
        let duration = timeInterval ?? 0 // Nil ise 0 olarak ayarla
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds) // Örneğin: "0:00", "5:09"
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "-" } // Eğer nil ise "-" döndür
        return dateFormatter.string(from: date)
    }
    
    func formatDuration(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return "\(minutes):\(String(format: "%02d", remainingSeconds))"
    }

    func getReportData() {
        let sortedPainLists = Constants.shared.painLists.sorted { $0.processNo > $1.processNo }
        
        var totalDuration: TimeInterval = 0
        var totalFrequency: TimeInterval = 0
        var durationCount: Int = 0
        var frequencyCount: Int = 0
        
        for (index, item) in sortedPainLists.enumerated() {
            let nextItem = sortedPainLists.indices.contains(index - 1) ? sortedPainLists[index - 1] : nil
            
            // `processEndTime` Optional olduğu için kontrol ediliyor
            if let endTime = item.processEndTime {
                let duration = endTime.timeIntervalSince(item.processStartTime)
                totalDuration += duration
                durationCount += 1
            }
            
            // Eğer `nextItem` varsa ve `processEndTime` nil değilse, frekans hesapla
            if let nextItem = nextItem, let currentEndTime = item.processEndTime {
                let frequency = nextItem.processStartTime.timeIntervalSince(currentEndTime)
                totalFrequency += frequency
                frequencyCount += 1
            }
        }
        
        let durationAvg = durationCount > 0 ? totalDuration / Double(durationCount) : 0
        let frequencyAvg = frequencyCount > 0 ? totalFrequency / Double(frequencyCount) : 0
        
        self.avgDuration = formatDuration(durationAvg)
        self.avgFrequency = formatDuration(frequencyAvg)
        
    }

    
    func getRapor() -> [ReportData] {
        
        let sortedPainLists = Constants.shared.painLists.sorted { $0.processNo > $1.processNo }

        var newReportList: [ReportData] = []

        for (index, item) in sortedPainLists.enumerated() {
            //let nextItem = sortedPainLists[index + 1]
            
            let nextItem = sortedPainLists.indices.contains(index - 1) ? sortedPainLists[index - 1] : nil

            let reportItem = ReportData(
                processNo: item.processNo,
                processStartTime: formattedDate(item.processStartTime),
                processEndTime: formattedDate(item.processEndTime),
                painIntensity: "\(item.painIntensity ?? 0)",
                processDateDifferent: formatDuration(item.processEndTime?.timeIntervalSince(item.processStartTime)),
                painRange: formatDuration(nextItem?.processStartTime.timeIntervalSince(item.processEndTime!)) + "(\(nextItem?.processNo ?? 0))"
            )

            newReportList.append(reportItem)
        }
        
        return newReportList
    }
    
    //geçici bir fonksiyon
    func loadPaingList2(modelContext: ModelContext) {
        Task {
            print("✅ Ters liste: \(Constants.shared.painLists.count)")
            for record in Constants.shared.painLists.reversed() {
                print("📌 processNo: \(record.processNo), StartTime: \(record.processStartTime)")
            }

            print("✅ Düz liste: \(Constants.shared.painLists.count)")
            for record in Constants.shared.painLists {
                print("📌 processNo: \(record.processNo), StartTime: \(record.processStartTime)")
            }
        }
    }
    
    func getMailList(modelContext: ModelContext) {
        Task {
            do {
                // FetchDescriptor ile veritabanından tüm Contact kayıtlarını çek
                let descriptor = FetchDescriptor<Contact>()
                let results = try modelContext.fetch(descriptor)
                
                // Her bir Contact nesnesinden email'i al ve boş olmayanları filtrele
                let filteredEmails = results.compactMap { $0.email }
                                             .filter { !$0.isEmpty }
                
                // Ensure the update to emailList happens on the main thread
                await MainActor.run {
                    self.emailList = filteredEmails
                }
                
            } catch {
                // Hata durumunda completion handler ile hatayı döndür
                await MainActor.run {
                    self.emailList = []
                }
            }
        }
    }
    
    
    func deleteAllProcesses(modelContext: ModelContext) {
        Task {
            do {
                // Tüm kayıtları çek
                let descriptor = FetchDescriptor<PainIntensity>()
                let results = try modelContext.fetch(descriptor)

                // ModelContext'ten tüm kayıtları sil
                for process in results {
                    modelContext.delete(process)
                }

                // Değişiklikleri kaydet
                try modelContext.save()
                
                DispatchQueue.main.async {
                    Constants.shared.painLists.removeAll() // Listeyi temizle
                }

                print("✅ Tüm kayıtlar başarıyla silindi. Silinen kayıt sayısı: \(results.count)")
            } catch {
                print("❌ Kayıtları silerken hata oluştu: \(error.localizedDescription)")
            }
        }
    }

    
    func changeScreen(_ screen: Screens) {
        self.screen = screen
    }
    
}
