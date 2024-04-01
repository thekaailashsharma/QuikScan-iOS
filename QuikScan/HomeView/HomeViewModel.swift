//
//  HomeViewModel.swift
//  QuikScan
//
//  Created by Kailash on 01/04/24.
//

import SwiftUI

enum Images: String {
    case urlNone = "url_none"
    case urlLinkedIn = "url_linkedIN"
    case urlMedium = "url_medium"
    case urlTwitter = "url_twitter"
    case urlGithub = "url_github"
    case urlFacebook = "url_facebook"
    case urlWhatsapp = "url_whatsapp"
    case urlInstagram = "url_instagram"
    case barMail = "bar_mail"
    case barSMS = "bar_sms"
    case barPhone = "bar_phone"
    case barvCard = "bar_vcard"
    case barText = "bar_text"
    case barCode = "barcode"
}

class HomeViewModel: ObservableObject {
    
    @Published var image: Images = .barCode
    
    func getImage(for barcodeType: BarCodeTypes) -> Images {
        switch barcodeType {
        case .qrCode(let qrCodeType):
            switch qrCodeType {
            case .url(let urlType):
                return getUrlImage(for: urlType)
            case .vcard:
                return .barvCard
            case .email:
                return .barMail
            case .phoneNumber:
                return .barPhone
            case .sms:
                return .barSMS
            case .text:
                return .barText
            case .none:
                return .barCode
            }
        case .barCode:
            return .barCode
        }
    }
    
    func getImageType(for urlString: String) -> Images? {
        guard let url = URL(string: urlString) else {
            print("Url Null")
            return .barCode // Invalid URL
        }

        switch url.host {
        case "linkedin.com":
            return .urlLinkedIn
        case "instagram.com":
            return .urlInstagram
        case "facebook.com":
            return .urlFacebook
        case "twitter.com":
            return .urlTwitter
        case "medium.com":
            return .urlMedium
        case "github.com":
            return .urlGithub
        case "whatsapp.com":
            return .urlWhatsapp
        default:
            print("Url Default")
            return .barCode // Unknown host
        }
    }


    func getUrlImage(for urlType: UrlTypes) -> Images {
        switch urlType {
        case .linkedIn:
            return .urlLinkedIn
        case .instaGram:
            return .urlInstagram
        case .facebook:
            return .urlFacebook
        case .twitter:
            return .urlTwitter
        case .medium:
            return .urlMedium
        case .github:
            return .urlGithub
        case .whatsapp:
            return .urlWhatsapp
        case .none:
            return .urlNone
        }
    }


    
}
