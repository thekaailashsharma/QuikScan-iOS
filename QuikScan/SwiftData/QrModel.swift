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
    var isEdited: Bool? = false
    var imageName: String? = nil
    var type: String
    
    init(time: Date, name: String, isPinned: Bool? = nil, isEdited: Bool? = nil, imageName: String? = nil, type: String) {
        self.time = time
        self.name = name
        self.isPinned = isPinned
        self.isEdited = isEdited
        self.imageName = imageName
        self.type = type
    }
    
    func contains(_ value: String) -> Bool {
        name.range(of: value, options: .caseInsensitive) != nil ||
        type.range(of: value, options: .caseInsensitive) != nil
    }
    
}

