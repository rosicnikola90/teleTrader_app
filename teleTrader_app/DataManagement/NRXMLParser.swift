//
//  XmlParser.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 22/01/2022.
//

import Foundation

final class NRXMLParser: NSObject {
    
    //MARK: - properties
    private var xmlParser: XMLParser?
    private var symbols: [Symbol] = []
    private var currentSymbol: Symbol?
    private var currentQuote: Quote?
    
    //MARK: - init
    init(withXML xml: String) {
        if let data = xml.data(using: String.Encoding.utf8) {
            xmlParser = XMLParser(data: data)
        }
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
}

//MARK: - delegate extension
extension NRXMLParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "Symbol" {
            currentSymbol = Symbol()
            
            if let name = attributeDict["name"] as String? {
                currentSymbol?.name = name
            }
            if let id = attributeDict["id"] as String? {
                currentSymbol?.id = id
            }
            if let tickerSymbol = attributeDict["tickerSymbol"] as String? {
                currentSymbol?.id = tickerSymbol
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
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Quote" {
            currentSymbol?.quote = currentQuote
        }
        else if elementName == "Symbol" {
            if let symbol = currentSymbol {
                symbols.append(symbol)
            }
        }
    }
}
