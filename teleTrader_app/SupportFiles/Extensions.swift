//
//  Extensions.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 22/01/2022.
//

import Foundation

extension String {
    
    func roundedOnTwoDecimals() -> String? {
        guard let doubleValue = Double(self) else { return "nil" }
        return String(format: "%.2f", doubleValue)
    }
}
