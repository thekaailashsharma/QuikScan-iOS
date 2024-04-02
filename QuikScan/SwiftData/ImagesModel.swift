//
//  HomeViewModel.swift
//  QuikScan
//
//  Created by Kailash on 01/04/24.
//

import SwiftUI

enum Images: String, CaseIterable {
    case url = "url"
    case linkedIn = "linkedIN"
    case medium = "medium"
    case twitter = "twitter"
    case urlGithub = "github"
    case urlFacebook = "facebook"
    case urlWhatsapp = "whatsapp"
    case urlInstagram = "instagram"
    case barMail = "mail"
    case barSMS = "sms"
    case barPhone = "phone"
    case barvCard = "vcard"
    case barText = "text"
    case barCode = "barcode"
    case dummy1 = "barcodes"
    case dummy2 = "barcode1"
}

extension Images {
    static func fromString(_ rawValue: String) -> Images {
        return Images(rawValue: rawValue) ?? .barCode
    }
}

let allImages: [Images] = [
    .url,
    .linkedIn,
    .medium,
    .twitter,
    .urlGithub,
    .urlFacebook,
    .urlWhatsapp,
    .urlInstagram,
    .barMail,
    .barSMS,
    .barPhone,
    .barvCard,
    .barText,
    .barCode,
    // Add dummy values here
    .dummy1,
    .dummy2
]

