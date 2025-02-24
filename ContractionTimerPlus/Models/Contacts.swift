//
//  Contact.swift
//  Contraction Timer Plus 9m
//
//  Created by ismail örkler on 22.02.2025.
//
import SwiftUI
import SwiftData

@Model
class Contact
{
    @Attribute(.unique) var contactNo: Int = 0
    var name: String
    var email: String?
    var phone: String?
    
    var contact: Bool = false
    var urgent: Bool = false

    init(contactNo: Int, name: String, email: String?, phone: String?, contact: Bool, urgent: Bool)
    {
        self.contactNo = contactNo
        self.name = name
        self.email = email
        self.phone = phone
        self.contact = contact
        self.urgent = urgent
    }
}
