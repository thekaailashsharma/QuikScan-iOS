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
}
