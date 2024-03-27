//
//  DummyMarquee.swift
//  QuikScan
//
//  Created by Kailash on 28/03/24.
//

import SwiftUI

var yellow = #colorLiteral(red: 0.9513035417, green: 0.7191032171, blue: 0.2411221564, alpha: 1)
var red = #colorLiteral(red: 0.9960784314, green: 0.1647058824, blue: 0.1647058824, alpha: 1)
var blue = #colorLiteral(red: 0.1058823529, green: 0.2823529412, blue: 0.6196078431, alpha: 1)

struct MarqueeIcon: Identifiable {
    var id: UUID = .init()
    var name: String
    var color: Color
    var icon: String
}

var iconsList = [
    MarqueeIcon(name: "Scan", color: Color(uiColor: blue), icon: "scan"),
    MarqueeIcon(name: "Share", color: Color(uiColor: red), icon: "share"),
    MarqueeIcon(name: "Save", color: Color(uiColor: yellow), icon: "save"),
]
