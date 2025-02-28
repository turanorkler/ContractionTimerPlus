//
//  MailSender.swift
//  ContractionTimerPlus
//
//  Created by ismail örkler on 28.02.2025.
//

import UIKit
import MessageUI

class MailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    func sendEmail(to recipients: [String], subject: String, body: String) {
        guard MFMailComposeViewController.canSendMail() else {
            print("Mail servisi kullanılamıyor")
            return
        }
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(recipients) // Alıcılar
        mailComposer.setSubject(subject) // Konu
        mailComposer.setMessageBody(body, isHTML: false) // İçerik
        
        present(mailComposer, animated: true, completion: nil)
    }
    
    // Kullanıcı mail gönderme ekranını kapattığında çağrılır
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
