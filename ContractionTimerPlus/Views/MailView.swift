//
//  MailSender.swift
//  ContractionTimerPlus
//
//  Created by ismail örkler on 3.03.2025.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    let recipients: [String]
    let subject: String
    let body: String
    let attachmentData: Data?
    let attachmentMimeType: String?
    let attachmentFileName: String?
    
    var onError: ((Error) -> Void)? // Hata bildirimi için closure
    
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIViewController {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = context.coordinator
            
            // E-posta bilgilerini ayarla
            mailComposeVC.setToRecipients(recipients)
            mailComposeVC.setSubject(subject)
            mailComposeVC.setMessageBody(body, isHTML: true)
            
            if let attachmentData = attachmentData,
               let attachmentMimeType = attachmentMimeType,
               let attachmentFileName = attachmentFileName {
                mailComposeVC.addAttachmentData(attachmentData, mimeType: attachmentMimeType, fileName: attachmentFileName)
            }
            
            return mailComposeVC
        } else {
            // Cihazda e-posta gönderme yeteneği yoksa bir uyarı göster
            let error = NSError(domain: "MailError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Cihazınızda e-posta hesabı bulunamadı. Lütfen Ayarlar'dan bir e-posta hesabı ekleyin."])
            onError?(error)
            return UIViewController() // Boş bir view controller döndür
        }
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView

        init(parent: MailView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if let error = error {
                print("❌ Mail gönderme hatası: \(error.localizedDescription)")
                parent.onError?(error) // Hata olduğunda onError çağrılır
            } else {
                switch result {
                case .cancelled:
                    print("⚠️ Kullanıcı mail göndermeyi iptal etti.")
                case .saved:
                    print("💾 Mail taslak olarak kaydedildi.")
                case .sent:
                    print("✅ Mail başarıyla gönderildi.")
                case .failed:
                    print("❌ Mail gönderme başarısız oldu.")
                @unknown default:
                    print("🔴 Bilinmeyen bir hata oluştu.")
                }
            }
            controller.dismiss(animated: true) {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
/*
struct MailView: UIViewControllerRepresentable {
    let recipients: [String]
    let subject: String
    let body: String
    let attachmentData: Data?
    let attachmentMimeType: String?
    let attachmentFileName: String?
    
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView

        init(parent: MailView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if let error = error {
                print("❌ Mail gönderme hatası: \(error.localizedDescription)")
            } else {
                switch result {
                case .cancelled:
                    print("⚠️ Kullanıcı mail göndermeyi iptal etti.")
                case .saved:
                    print("💾 Mail taslak olarak kaydedildi.")
                case .sent:
                    print("✅ Mail başarıyla gönderildi.")
                case .failed:
                    print("❌ Mail gönderme başarısız oldu.")
                @unknown default:
                    print("🔴 Bilinmeyen bir hata oluştu.")
                }
            }
            controller.dismiss(animated: true) {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        guard MFMailComposeViewController.canSendMail() else {
            print("⚠️ Cihaz mail gönderemiyor. Lütfen bir mail hesabı ekleyin.")
            return MFMailComposeViewController()
        }

        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = context.coordinator

        print("📧 Mail gönderilecek kişiler: \(recipients)") // ✅ Kime gidecekleri kontrol et

        if recipients.isEmpty {
            print("⚠️ HATA! Alıcı listesi boş! Manuel ekleme gerekecek.")
        } else {
            mailComposeVC.setToRecipients(recipients) // ✅ Kişileri ekle
        }

        mailComposeVC.setSubject(subject)
        mailComposeVC.setMessageBody(body, isHTML: false)

        if let attachmentData = attachmentData {
            print("📎 Eklenen dosya: \(String(describing: attachmentFileName)), Boyut: \(attachmentData.count) byte") // ✅ Dosya ekleme kontrolü
            mailComposeVC.addAttachmentData(attachmentData, mimeType: attachmentMimeType!, fileName: attachmentFileName!)
        } else {
            print("⚠️ HATA! Ek dosya bulunamadı!")
        }

        return mailComposeVC
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}
*/
