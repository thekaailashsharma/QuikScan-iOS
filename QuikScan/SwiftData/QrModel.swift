//
//  QrModel.swift
//  QuikScan
//
//  Created by Kailash on 01/04/24.
//

import SwiftUI
import SwiftData

@Model
class QrModel: Identifiable {
    @Attribute(.unique) var time: Date
    var name: String
    var isPinned: Bool? = false
    var isUrl: Bool? = false
    var isPhone: Bool? = false
    var isvCard: Bool? = false
    var isemail: Bool? = false
    var isSms: Bool? = false
    var isBarCode: Bool? = true
    var isText: Bool? = false
    var url: String? = nil
    var barCode: String? = nil
    var phone: String? = nil
    var email: String? = nil
    var sms: String? = nil
    var vCard: VCard? = nil
    var text: String? = nil
    
    init(time: Date, name: String, isPinned: Bool? = nil, isUrl: Bool? = nil, isPhone: Bool? = nil, isvCard: Bool? = nil, isemail: Bool? = nil, isSms: Bool? = nil, isBarCode: Bool? = nil, isText: Bool? = nil, url: String? = nil, barCode: String? = nil, phone: String? = nil, email: String? = nil, sms: String? = nil, vCard: VCard? = nil, text: String? = nil) {
        self.time = time
        self.name = name
        self.isPinned = isPinned
        self.isUrl = isUrl
        self.isPhone = isPhone
        self.isvCard = isvCard
        self.isemail = isemail
        self.isSms = isSms
        self.isBarCode = isBarCode
        self.isText = isText
        self.url = url
        self.barCode = barCode
        self.phone = phone
        self.email = email
        self.sms = sms
        self.vCard = vCard
        self.text = text
    }
    
    
    
}

