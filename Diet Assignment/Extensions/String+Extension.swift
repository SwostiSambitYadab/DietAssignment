//
//  String+Extension.swift
//  Diet Assignment
//
//  Created by Swosti Sambit Yadab on 21/06/25.
//

import Foundation

extension String {
    func to12HourFormat() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = self.contains(":") ? "HH:mm" : "HH"
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.dateFormat = "h:mm a"

        let trimmed = self.trimmingCharacters(in: .whitespaces)
        
        if let date = inputFormatter.date(from: trimmed) {
            return outputFormatter.string(from: date)
        } else {
            return self
        }
    }
}

