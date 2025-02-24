//
//  ContactViewModel.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 22.02.2025.
//

import SwiftData
import SwiftUI

@MainActor
class ContactsViewModel: ObservableObject {
    
    @Published var contactsLists: [Contact] = []
    @Published var selectedContact: Contact? // Seçili kişi (Düzenleme için)
    @Published var isEditing: Bool = false // PopUp Aç/Kapat

    // 📌 **Verileri Yükleme**
    func loadContacts(modelContext: ModelContext) {
        do {
            let descriptor = FetchDescriptor<Contact>()
            let results = try modelContext.fetch(descriptor)
            self.contactsLists = results
            
            print("📌 Kayıtlı kişi sayısı: \(self.contactsLists.count)")
        } catch {
            print("❌ Veri çekme hatası: \(error.localizedDescription)")
        }
    }

    // ✅ **Ekle veya Güncelle**
    func addOrUpdateContact(modelContext: ModelContext, contactNo: Int, name: String, email: String, phone: String, contact: Bool, urgent: Bool) {
        do {
            if contactNo == 0 {
                // ✅ Yeni kişi ekleme
                let newContact = Contact(contactNo: Int(Date().timeIntervalSince1970), name: name, email: email, phone: phone, contact: contact, urgent: urgent)
                modelContext.insert(newContact)
                print("✅ Yeni kişi eklendi: \(newContact.name)")
            } else {
                // ✅ Var olan kişiyi güncelle
                let descriptor = FetchDescriptor<Contact>(predicate: #Predicate { $0.contactNo == contactNo })
                if let existingContact = try modelContext.fetch(descriptor).first {
                    existingContact.name = name
                    existingContact.email = email
                    existingContact.phone = phone
                    existingContact.contact = contact
                    existingContact.urgent = urgent
                    print("✅ Kişi güncellendi: \(existingContact.name)")
                } else {
                    print("⚠️ Güncellenecek kişi bulunamadı!")
                }
            }
            
            // ✅ **Değişiklikleri kesin olarak kaydet**
            try modelContext.save()
            print("🛠 modelContext.save() çağrıldı.")

            // ✅ **Veri gerçekten kaydedilmiş mi?**
            let allContacts = try modelContext.fetch(FetchDescriptor<Contact>())
            print("✅ Veritabanında kişi sayısı: \(allContacts.count)")
            
            // ✅ UI Güncelleme
            self.loadContacts(modelContext: modelContext)
        } catch {
            print("❌ İşlem hatası: \(error.localizedDescription)")
        }
    }

    // ❌ **Tek Kişi Silme**
    func deleteContact(modelContext: ModelContext, contact: Contact) {
        do {
            modelContext.delete(contact)
            try modelContext.save()
            print("🗑 Kişi silindi: \(contact.name)")
            
            self.loadContacts(modelContext: modelContext)
        } catch {
            print("❌ Kişi silme hatası: \(error.localizedDescription)")
        }
    }

    // ❌ **Tüm Kişileri Silme**
    func deleteAllContacts(modelContext: ModelContext) {
        do {
            let fetchDescriptor = FetchDescriptor<Contact>()
            let allContacts = try modelContext.fetch(fetchDescriptor)
            for contact in allContacts {
                modelContext.delete(contact)
            }
            try modelContext.save()
            print("🗑 Tüm kişiler silindi.")
            
            self.loadContacts(modelContext: modelContext)
        } catch {
            print("❌ Tüm kişileri silme hatası: \(error.localizedDescription)")
        }
    }

    // 🔄 **Seçili Kişiyi Temizle**
    func clearSelection() {
        selectedContact = nil
        isEditing = false
    }
}
