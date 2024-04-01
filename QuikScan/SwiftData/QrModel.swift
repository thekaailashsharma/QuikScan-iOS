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
    var type: String
    
    init(time: Date, name: String, isPinned: Bool? = nil, type: String) {
        self.time = time
        self.name = name
        self.isPinned = isPinned
        self.type = type
    }
    
}

