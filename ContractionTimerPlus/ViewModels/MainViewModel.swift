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
    
    @Published var painLists: [PainIntensity] = []
    @Published var lastInsertedProcess: PainIntensity?
    
    @Published var screen : Screens = .start
    @Published var isLoading = false
    
    @Published var isError: Bool = false
    
    @Published var lastPainDate = "-"
    @Published var contractionCount = 0
    @Published var avgDuration = "0:00"
    @Published var avgFrequency = "0:00"
    
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
                let pain = self.painLists.max(by: { $0.processNo < $1.processNo })
                self.lastPainDate = self.formatDuration(Date().timeIntervalSince(pain?.processStartTime ?? Date()))
                self.contractionCount = self.painLists.count
            }
        }
    }
    
    func addProcess(modelContext: ModelContext) {
        
        let newProcessNo = (self.painLists.max(by: { $0.processNo < $1.processNo })?.processNo ?? 0) + 1

        let newProcess = PainIntensity(
            //processNo: self.painLists.count == 0 ? 1 : self.painLists.last!.processNo + 1,
            processNo: newProcessNo,
            processStartTime: Date(),
            processEndTime: nil,
            painIntensity: nil
        )
        
        DispatchQueue.main.async {
            self.lastInsertedProcess = newProcess
            self.painLists.append(newProcess) // Sadece listeye ekle, veritabanına kaydetme
            print("\(newProcess.processNo) Eklendi \(self.painLists.count)")
        }
    }

    
    func updateProcess(modelContext: ModelContext, newPainIntensity: Int) {
        Task {
            //let count = painLists.count + 1
            lastInsertedProcess?.painIntensity = newPainIntensity
            //lastInsertedProcess?.processNo = count
            
            do {
                if lastInsertedProcess != nil {
                    modelContext.insert(lastInsertedProcess!)
                    try modelContext.save()
                    print("✅ Kayıt başarıyla güncellendi: \(String(describing: lastInsertedProcess?.painIntensity))")
                }
            } catch {
                print("❌ Veritabanına kaydetme hatası: \(error.localizedDescription)")
            }

            print("🔍 Güncellenen Kayıt Sonrası -> processNo: \(String(describing: lastInsertedProcess?.processNo)), painIntensity: \(String(describing: lastInsertedProcess?.painIntensity))")
        }
    }


    
    func loadPaingList(modelContext: ModelContext) {
        Task {
            do {
                let descriptor = FetchDescriptor<PainIntensity>(
                    sortBy: [SortDescriptor(\.processNo, order: .reverse)] // Büyükten küçüğe sıralama
                )
                let results = try modelContext.fetch(descriptor)
                
                print("✅ Çekilen kayıtlar: \(results.count)")
                for record in results {
                    print("📌 processNo: \(record.processNo), StartTime: \(record.processStartTime)")
                }

                DispatchQueue.main.async {
                    self.painLists = results
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
        let sortedPainLists = painLists.sorted { $0.processNo > $1.processNo }
        
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
        
        let sortedPainLists = painLists.sorted { $0.processNo > $1.processNo }

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

    /*
    func getRapor()
    {
        //ReportData(processNo: 1, processStartTime: now, processEndTime: Calendar.current.date(byAdding: .minute, value: 20, to: now))
        painLists.forEach { (item) in
            item.
        }
    }
    */
    
    //geçici bir fonksiyon
    func loadPaingList2(modelContext: ModelContext) {
        Task {
            print("✅ Ters liste: \(self.painLists.count)")
            for record in self.painLists.reversed() {
                print("📌 processNo: \(record.processNo), StartTime: \(record.processStartTime)")
            }

            print("✅ Düz liste: \(self.painLists.count)")
            for record in self.painLists {
                print("📌 processNo: \(record.processNo), StartTime: \(record.processStartTime)")
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
                    self.painLists.removeAll() // Listeyi temizle
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
