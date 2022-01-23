//
//  News.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 23/01/2022.
//

import Foundation

class News {
    var id: String?
    var author: String?
    var dateTime: String?
    var sourceName: String?
    var headline: String?
    var tags: [Tag] = []
}

class Tag {
    var position: String?
    var picTT: PicTT?
    var linkedSymbols: [LinkedSymbol] = []
}

class PicTT {
    var imageID: String?
    var imageSource: String?
}

class LinkedSymbol {
    var isin: String?
    var exchangeID: String?
}
