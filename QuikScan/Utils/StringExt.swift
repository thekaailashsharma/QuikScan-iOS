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
    
    func mailTrim() -> String {
        guard let atIndex = self.firstIndex(of: "@") else {
            return self
        }
        let username = self[..<atIndex]
        return String(username)
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
    
    func extractDomainFromEmail() -> String? {
        guard let atIndex = self.firstIndex(of: "@") else {
            return nil
        }
        let domain = self[self.index(after: atIndex)...]
        return String(domain)
    }
    
}
