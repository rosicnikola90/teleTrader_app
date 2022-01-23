//
//  DateManager.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 23/01/2022.
//

import Foundation

final class DateManager {
    
    static let shared = DateManager()
    
    private init() {}
    private let formatter = DateFormatter()
    
    public func toDate(from string: String) -> Date? {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        guard let date = formatter.date(from: string) else { return nil }
        return date
    }
    
}
