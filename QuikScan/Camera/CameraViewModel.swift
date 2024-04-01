//
//  CameraViewModel.swift
//  QuikScan
//
//  Created by Kailash on 30/03/24.
//

import SwiftUI
import AVKit
import Contacts

@MainActor
class CameraViewModel: ObservableObject {
    
    @Published var qrCodeInfo: QRCodeInfo = .init(type: .none)
    
    func parseQRCode(_ data: String) -> QRCodeInfo {
        if data.hasPrefix("BEGIN:VCARD") && data.contains("END:VCARD") {
            // Parse vCard
            let vCard = parseVCard(data)
            print("Data is \(vCard)")
            return QRCodeInfo(type: .vcard(vCard))
        } else if data.lowercased().hasPrefix("http://") || data.lowercased().hasPrefix("https://") {
            // Parse URL
            if let url = URL(string: data) {
                return QRCodeInfo(type: .url(url))
            }
        } else if data.lowercased().hasPrefix("tel:") {
            return QRCodeInfo(type: .phoneNumber(data.replacingOccurrences(of: "tel:", with: "")))
        } else if data.lowercased().hasPrefix("mailto:") {
            let email = parseEmail(data)
            return QRCodeInfo(type: .email(email))
        } else if data.lowercased().hasPrefix("smsto:") {
            let message = parseSMSMessage(data)
            return QRCodeInfo(type: .sms(message))
        }
        // Add more parsing logic for other types of QR codes
        return .init(type: .text(data))
    }
    
    func parseVCard(_ data: String) -> VCard {
        var vCard = VCard(fullName: "", lastName: "", firstName: "", additionalName: "", namePrefix: "", nameSuffix: "", nickname: "", organization: "", jobTitle: "", department: "", phoneNumbers: [], emails: [], urls: [])
        
        // Split the data into lines
        let lines = data.uppercased().components(separatedBy: .newlines)
        
        for line in lines {
            // Split each line into key-value pairs
            let components = line.components(separatedBy: ":")
            print("Components is \(components)")
            if components.count == 2 {
                let key = components[0]
                let value = components[1]
                switch key {
                case "FN":
                    vCard.fullName = value
                case "N":
                    // Split name into components
                    let nameComponents = value.components(separatedBy: ";")
                    if nameComponents.count >= 2 {
                        vCard.lastName = nameComponents[0]
                        vCard.firstName = nameComponents[1]
                    }
                case "ORG":
                    vCard.organization = value
                case "TITLE":
                    vCard.jobTitle = value
                case "TEL":
                    vCard.phoneNumbers.append(value)
                case "EMAIL;TYPE=INTERNET":
                    vCard.emails.append(value)
                case "URL":
                    if let url = URL(string: value) {
                        vCard.urls.append(url)
                    }
                default:
                    break
                }
            }
        }
        
        return vCard
    }
    
    func parseEmail(_ data: String) -> Email? {
        guard data.hasPrefix("mailto:") else {
            return nil
        }
        
        var email = Email(address: "", subject: nil, body: nil)
        
        // Remove "mailto:" prefix
        let startIndex = data.index(data.startIndex, offsetBy: 7)
        let emailString = String(data[startIndex...])
        
        // Split the email string into components
        let components = emailString.components(separatedBy: "?")
        email.address = components[0]
        
        // Parse query parameters
        if components.count > 1 {
            let queryItems = components[1].components(separatedBy: "&")
            for item in queryItems {
                let keyValue = item.components(separatedBy: "=")
                if keyValue.count == 2 {
                    let key = keyValue[0]
                    let value = keyValue[1]
                    switch key {
                    case "subject":
                        email.subject = value.removingPercentEncoding
                    case "body":
                        email.body = value.removingPercentEncoding
                    default:
                        break
                    }
                }
            }
        }
        
        return email
    }
    
    func convertEmailToCNLabeledValue(_ emails: [String]) -> [CNLabeledValue<NSString>] {
        var labeledEmails: [CNLabeledValue<NSString>] = []
        
        for email in emails {
            let labeledValue = CNLabeledValue(label: CNLabelWork, value: NSString(string: email))
            labeledEmails.append(labeledValue)
        }
        
        return labeledEmails
    }
    
    func convertPhoneToCNPhoneNumbers(_ phoneNumbers: [String]) -> [CNLabeledValue<CNPhoneNumber>] {
        var labeledPhoneNumbers: [CNLabeledValue<CNPhoneNumber>] = []
        
        for phoneNumberString in phoneNumbers {
            let phoneNumber = CNPhoneNumber(stringValue: phoneNumberString)
            let labeledPhoneNumber = CNLabeledValue(label: CNLabelPhoneNumberMain, value: phoneNumber)
            labeledPhoneNumbers.append(labeledPhoneNumber)
        }
        
        return labeledPhoneNumbers
    }
    
    func parseSMSMessage(_ data: String) -> SMSMessage? {
        guard data.lowercased().hasPrefix("smsto:") else {
            return nil
        }
        
        // Remove "smsto:" prefix
        let startIndex = data.index(data.startIndex, offsetBy: 6)
        let smsString = String(data[startIndex...])
        
        // Split the sms string into components
        let components = smsString.components(separatedBy: ":")
        guard components.count == 2 else {
            return nil
        }
        
        let phoneNumber = components[0]
        let message = components[1]
        
        return SMSMessage(phoneNumber: phoneNumber, message: message)
    }
    
    func isValidURL(_ string: String) -> Bool {
        guard let url = URL(string: string),
              let scheme = url.scheme?.lowercased() else {
            print("Error creating URL")
            return false
        }
        
        // Check if the scheme is HTTP or HTTPS
        return scheme == "http" || scheme == "https"
    }
    
    func placeCall(number: String) {
        guard let url = URL(string: "tel:\(number)") else {
            print("Invalid phone number")
            return
        }
        
        UIApplication.shared.open(url, options: [:]) { success in
            if success {
                print("Call placed successfully")
            } else {
                print("Failed to place call")
            }
        }
    }
    
    func getImage(for string: String) -> Images {
        var temp = parseQRCode(string)
        return parseImage(for: temp)
    }
    
    private func parseImage(for qrCodeInfo: QRCodeInfo) -> Images {
        switch qrCodeInfo.type {
        case .url(let url):
            switch url.host {
            case "linkedin.com":
                return .urlLinkedIn
            case "medium.com":
                return .urlMedium
            case "twitter.com":
                return .urlTwitter
            case "github.com":
                return .urlGithub
            case "facebook.com":
                return .urlFacebook
            case "whatsapp.com":
                return .urlWhatsapp
            case "instagram.com":
                return .urlInstagram
            default:
                return .urlNone
            }
        case .email:
            return .barMail
        case .phoneNumber:
            return .barPhone
        case .sms:
            return .barSMS
        case .vcard:
            return .barvCard
        case .text:
            return .barText
        default:
            return .barCode
        }
    }

    
}
