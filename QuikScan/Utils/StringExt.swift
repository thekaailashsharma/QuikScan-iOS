//
//  StringExt.swift
//  QuikScan
//
//  Created by Kailash on 01/04/24.
//

import SwiftUI

extension String {
    func truncate(length: Int, trailing: String = "…") -> String {
        return count > length ? prefix(length) + trailing : self
    }
    
    func urlTrim() -> String {
        return self.lowercased().customTrim(["http://", "https://", "www."])
            .customTrim(["github.com/", "instagram.com/", "medium.com/", "wa.me/", "whatsapp.com/", "x.com/", "twitter.com/", "facebook.com/", "linkedin.com/"])
    }
    
    func customTrim(_ prefixes: [String]) -> String {
        var result = self
        for pattern in prefixes {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                let range = NSRange(location: 0, length: result.utf16.count)
                result = regex.stringByReplacingMatches(in: result, options: [], range: range, withTemplate: "")
            }
        }
        if result.count >= 4 {
            return result
        } else {
            return self // Return the original string
        }
    }
    
}
