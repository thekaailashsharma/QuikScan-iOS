//
//  DateExt.swift
//  QuikScan
//
//  Created by Kailash on 02/04/24.
//

import SwiftUI

extension Date {
    func getTimeAgo() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear], from: self, to: now)

        if let week = components.weekOfYear, week > 0 {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: self)
        }
        if let day = components.day, day > 0 {
            return "\(day) day\(day == 1 ? "" : "s") ago"
        }
        if let hour = components.hour, hour > 0 {
            return "\(hour) hour\(hour == 1 ? "" : "s") ago"
        }
        if let minute = components.minute, minute > 0 {
            return "\(minute) minute\(minute == 1 ? "" : "s") ago"
        }
        return "Just now"
    }
    
    func localTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func timeAgo() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current)
    }
}

extension Dictionary where Key == String, Value == [QrModel] {
    func sortedMyModel(by sortOrder: ComparisonResult) -> [(String, [QrModel])] {
        return sorted { (lhs, rhs) -> Bool in
            let lhsDate = lhs.value.first?.time ?? Date()
            let rhsDate = rhs.value.first?.time ?? Date()
            return lhsDate.compare(rhsDate) == sortOrder
        }
    }
}



