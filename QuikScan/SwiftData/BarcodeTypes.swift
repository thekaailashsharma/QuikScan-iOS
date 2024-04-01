//
//  BarcodeTypes.swift
//  QuikScan
//
//  Created by Kailash on 01/04/24.
//

import SwiftUI

enum BarCodeTypes: CaseIterable, Codable {
    case qrCode(AllQRCodeType)
    case barCode(String)
    
    static var allCases: [BarCodeTypes] {
        return [
            .qrCode(.none),
            .barCode("")
        ]
    }
}

enum AllQRCodeType: Codable {
    case text(String)
    case url(UrlTypes)
    case vcard(VCard)
    case email(Email?)
    case phoneNumber(String)
    case sms(SMSMessage?)
    case none
}

enum UrlTypes: Codable {
    case linkedIn(URL)
    case instaGram(URL)
    case facebook(URL)
    case twitter(URL)
    case medium(URL)
    case github(URL)
    case whatsapp(URL)
    case none(URL)
}

