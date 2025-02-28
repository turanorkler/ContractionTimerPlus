//
//  SMSViewController.swift
//  ContractionTimerPlus
//
//  Created by ismail örkler on 28.02.2025.
//

import UIKit
import MessageUI

class SMSViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    func sendSMS(to recipients: [String], message: String) {
        guard MFMessageComposeViewController.canSendText() else {
            print("SMS servisi kullanılamıyor")
            return
        }
        
        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = self
        messageComposer.recipients = recipients
        messageComposer.body = message
        
        present(messageComposer, animated: true, completion: nil)
    }
    
    // Kullanıcı SMS ekranını kapattığında çağrılır
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
}
