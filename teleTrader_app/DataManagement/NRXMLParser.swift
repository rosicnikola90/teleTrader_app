//
//  XmlParser.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 22/01/2022.
//

import Foundation

enum XMLParseType {
    case symbol
    case news
}

final class NRXMLParser: NSObject {
    
    //MARK: - properties
    private let parseType: XMLParseType
    private var xmlParser: XMLParser?
    private var xmlText = ""
    
    private var symbols: [Symbol] = []
    private var currentSymbol: Symbol?
    private var currentQuote: Quote?
    
    private var newsArray: [News] = []
    private var currentNews: News?
    private var currentTag: Tag?
    private var currentPicTT: PicTT?
    private var currentLinkedSymbol: LinkedSymbol?
    
    //MARK: - init
    init(withXML xml: String, forXMLType type: XMLParseType) {
        if let data = xml.data(using: String.Encoding.utf8) {
            xmlParser = XMLParser(data: data)
        }
        self.parseType = type
    }
    
    deinit {
        print("NRXMLParser deinit")
    }
    
    /// parse Xml String and returns array of Symbol models
    func parseSymbols() -> [Symbol] {
        xmlParser?.delegate = self
        xmlParser?.parse()
        return symbols
    }
    
    ///parse Xml String and returns array of News models
    func parseNews() -> [News] {
        xmlParser?.delegate = self
        xmlParser?.parse()
        return newsArray
    }
}

//MARK: - delegate extension
extension NRXMLParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        xmlText = ""
        switch parseType {
        case .symbol:
            if elementName == "Symbol" {
                currentSymbol = Symbol()
                
                if let name = attributeDict["name"] as String? {
                    currentSymbol?.name = name
                }
                if let id = attributeDict["id"] as String? {
                    currentSymbol?.id = id
                }
                if let tickerSymbol = attributeDict["tickerSymbol"] as String? {
                    currentSymbol?.tickerSymbol = tickerSymbol
                }
                if let isin = attributeDict["isin"] as String? {
                    currentSymbol?.isin = isin
                }
                if let currency = attributeDict["currency"] as String? {
                    currentSymbol?.currency = currency
                }
                if let stockExchangeName = attributeDict["stockExchangeName"] as String? {
                    currentSymbol?.stockExchangeName = stockExchangeName
                }
                if let decorativeName = attributeDict["decorativeName"] as String? {
                    currentSymbol?.decorativeName = decorativeName
                }
            }
            if elementName == "Quote" {
                currentQuote = Quote()
                
                if let last = attributeDict["last"] as String? {
                    currentQuote?.last = last
                }
                if let high = attributeDict["high"] as String? {
                    currentQuote?.high = high
                }
                if let low = attributeDict["low"] as String? {
                    currentQuote?.low = low
                }
                if let volume = attributeDict["volume"] as String? {
                    currentQuote?.volume = volume
                }
                if let dateTime = attributeDict["dateTime"] as String? {
                    currentQuote?.dateTime = dateTime
                }
                if let change = attributeDict["change"] as String? {
                    currentQuote?.change = change
                }
                if let changePercent = attributeDict["changePercent"] as String? {
                    currentQuote?.changePercent = changePercent
                }
            }
        case .news:
            if elementName == "NewsArticle" {
                currentNews = News()
                
                if let id = attributeDict["id"] as String? {
                    currentNews?.id = id
                }
                if let author = attributeDict["author"] as String? {
                    currentNews?.author = author
                }
                if let time = attributeDict["dateTime"] as String? {
                    currentNews?.dateTime = time
                }
                if let sourceName = attributeDict["sourceName"] as String? {
                    currentNews?.sourceName = sourceName
                }
            }
            if elementName == "Tag" {
                currentTag = Tag()
                if let position = attributeDict["position"] as String? {
                    currentTag?.position = position
                }
            }
            
            if elementName == "PicTT" {
                currentPicTT = PicTT()
            }
            if elementName == "Symbol" {
                currentLinkedSymbol = LinkedSymbol()
                if let isin = attributeDict["isin"] as String? {
                    currentLinkedSymbol?.isin = isin
                }
                if let exchangeID = attributeDict["exchangeID"] as String? {
                    currentLinkedSymbol?.exchangeID = exchangeID
                }
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch parseType {
        case .symbol:
            if elementName == "Quote" {
                currentSymbol?.quote = currentQuote
            }
            else if elementName == "Symbol" {
                if let symbol = currentSymbol {
                    symbols.append(symbol)
                }
            }
        case .news:
            if elementName == "Tag" {
                if let news = currentNews, let tag = currentTag {
                    news.tags.append(tag)
                }
            }
            if elementName == "ImageID" {
                if let picTT = currentPicTT {
                    picTT.imageID = xmlText
                }
            }
            if elementName == "ImageSource" {
                if let picTT = currentPicTT {
                    picTT.imageSource = xmlText
                }
            }
            if elementName == "PicTT" {
                if let picTT = currentPicTT, let tag = currentTag {
                    tag.picTT = picTT
                }
            }
            if elementName == "Symbol" {
                if let tag = currentTag, let linkedSymbol = currentLinkedSymbol {
                    tag.linkedSymbols.append(linkedSymbol)
                }
            }
            if elementName == "NewsArticle" {
                if let news = currentNews {
                    newsArray.append(news)
                }
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        switch parseType {
        case .news:
            if let headline = String(data: CDATABlock, encoding: String.Encoding.utf8) {
                if let news = currentNews {
                    news.headline = headline
                }
            }
        default:
            return
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        xmlText += string
    }
}
