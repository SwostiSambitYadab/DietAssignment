//
//  Binding+Extension.swift
//  Diet Assignment
//
//  Created by Rahul Kiumar on 22/06/25.
//

import Foundation
import SwiftUI

extension Binding where Value == Bool {
    init<T>(value: Binding<T?>) {
        self.init(
            get: {
                value.wrappedValue != nil
            }, set: { newValue in
                if !newValue {
                    value.wrappedValue = nil
                }
            }
        )
    }
}
