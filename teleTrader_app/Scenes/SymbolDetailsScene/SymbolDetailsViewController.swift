//
//  SymbolDetailsViewController.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 22/01/2022.
//

import UIKit

final class SymbolDetailsViewController: UIViewController {
    
    //MARK: - properties
    var symbol: Symbol?
    
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var tickerSymbol: UILabel!
    @IBOutlet weak var isin: UILabel!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var stockExchangeName: UILabel!
    @IBOutlet weak var decorativeName: UILabel!
    @IBOutlet weak var last: UILabel!
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var volume: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var change: UILabel!
    @IBOutlet weak var changePercent: UILabel!
    @IBOutlet weak var symbolName: UILabel!
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews(withSymbol: symbol)
    }
    
    private func setupViews(withSymbol symbol: Symbol?) {
        guard let symbol = symbol else { return }
        let defaultValue = "/"
        
        title = "Details"
        id.text = symbol.id
        symbolName.text = symbol.name                       ?? defaultValue
        tickerSymbol.text = symbol.tickerSymbol             ?? defaultValue
        isin.text = symbol.isin                             ?? defaultValue
        currency.text = symbol.currency                     ?? defaultValue
        stockExchangeName.text = symbol.stockExchangeName   ?? defaultValue
        decorativeName.text = symbol.decorativeName         ?? defaultValue
        last.text = symbol.quote?.last                      ?? defaultValue
        high.text = symbol.quote?.high                      ?? defaultValue
        low.text = symbol.quote?.low                        ?? defaultValue
        volume.text = symbol.quote?.volume                  ?? defaultValue
        dateTime.text = symbol.quote?.dateTime              ?? defaultValue
        change.text = symbol.quote?.change                  ?? defaultValue
        changePercent.text = symbol.quote?.changePercent    ?? defaultValue
    }

}
