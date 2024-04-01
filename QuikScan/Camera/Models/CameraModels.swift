//
//  CameraModels.swift
//  QuikScan
//
//  Created by Kailash on 30/03/24.
//

import SwiftUI

enum Permissions: String {
    case idle = "Not Determined"
    case approved = "Access Granted"
    case denied = "Access Denied"
}

enum QRCodeType: Codable {
    case text(String)
    case url(URL)
    case vcard(VCard)
    case email(Email?)
    case phoneNumber(String)
    case sms(SMSMessage?)
    case none
}

struct VCard: Codable {
    var fullName: String = ""
    var lastName: String = ""
    var firstName: String = ""
    var additionalName: String = ""
    var namePrefix: String = ""
    var nameSuffix: String = ""
    var nickname: String = ""
    var organization: String = ""
    var jobTitle: String = ""
    var department: String = ""
    var phoneNumbers: [String] = []
    var emails: [String] = []
    var urls: [URL] = []
}

struct SMSMessage: Codable {
    var phoneNumber: String
    var message: String
}

struct Email: Codable {
    var address: String
    var subject: String?
    var body: String?
}

struct QRCodeInfo {
    var type: QRCodeType
}
