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
                self.objectWillChange.send() // UI güncellenmesini tetikle
            }
        }
    }
    
    /*
    func addProcess(modelContext : ModelContext) {
        let newProcess = PaintIntensity(
            processStartTime: Date(),
            processEndTime: nil,
            painIntensity: nil // İlk başta `nil`
        )
        modelContext.insert(newProcess)
        try? modelContext.save()
        
        DispatchQueue.main.async {
            self.lastInsertedProcess = newProcess
            self.painLists.append(newProcess)
        }
        loadPaingList(modelContext: modelContext)
    }
    */
    
    func addProcess(modelContext: ModelContext) {
        let newProcess = PainIntensity(
            processNo: self.painLists.count == 0 ? 1 : self.painLists.last!.processNo + 1,
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
            /*guard let lastProcess = self.lastInsertedProcess else {
                print("❌ Güncellenecek kayıt bulunamadı.")
                return
            }

            print("🔍 Güncellenen Kayıt Öncesi -> processNo: \(lastProcess.processNo), painIntensity: \(String(describing: lastProcess.painIntensity))")
             */
            let count = painLists.count + 1
            lastInsertedProcess?.painIntensity = newPainIntensity
            lastInsertedProcess?.processNo = count
            
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
    
    
    func loadPaingList2(modelContext: ModelContext) {
        Task {
            do {
                print("✅ Ters liste: \(self.painLists.count)")
                for record in self.painLists.reversed() {
                    print("📌 processNo: \(record.processNo), StartTime: \(record.processStartTime)")
                }
                
                print("✅ Düz liste: \(self.painLists.count)")
                for record in self.painLists {
                    print("📌 processNo: \(record.processNo), StartTime: \(record.processStartTime)")
                }
                

            } catch {
                print("❌ Veri çekme hatası: \(error.localizedDescription)")
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
