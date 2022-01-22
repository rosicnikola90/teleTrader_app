//
//  Symbol.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 22/01/2022.
//

import Foundation

struct Symbol: Equatable {

    var id: String?
    var name: String?
    var tickerSymbol: String?
    var isin: String?
    var currency: String?
    var stockExchangeName: String?
    var decorativeName: String?
    var quote: Quote?
    
    static func == (lhs: Symbol, rhs: Symbol) -> Bool {
        return lhs.name == rhs.name
    }
}
