//
//  File.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 21/01/2022.
//

import Foundation

struct Constants {
    static let userNameForHeader = "android_tt"
    static let passwordForHeader = "Sk3M!@p9e"
    static let urlForSymbolList = "http://www.teletrader.rs/downloads/tt_symbol_list.xml"
    static let urlForNewsList = "http://www.teletrader.rs/downloads/tt_news_list.xml"
    static let prefixForURLToNewsImage = "https://cdn.ttweb.net/News/images/"
    static let sufixForURLToNewsImage = ".jpg?preset="
    static let sizeSufixMedium = "w320_q50"
    static let sizeSufixSmall = "w220_q40"
    static let sizeSufixLarge = "w800_q70"
    static let xmlStringNotification = "xmlStringNotification"
    static let timerCallNotificationName = "timerCall"
    static let rangeForTimerMin = 3.0
    static let rangeForTimerMax = 30.0
}
