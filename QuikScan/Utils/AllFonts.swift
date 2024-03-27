//
//  AllFonts.swift
//  QuikScan
//
//  Created by Kailash on 28/03/24.
//

import SwiftUI

enum Fonts: String {
    case poppins = "Poppins-Regular"
    case longline = "LonglineQuartFREE"
    case mitchela = "MitchaellaFreeModernUnique-Regu"
    case noctis = "Noctis-ThinItalic"
    case roasche = "RoashePersonalUse"
    case southam = "SouthamDemo"
    case angel = "Angeldemo-"
}

extension Font {
    static func customFont(_ font: Fonts, size: CGFloat) -> Font {
        return Font.custom(font.rawValue, size: size)
    }
}
