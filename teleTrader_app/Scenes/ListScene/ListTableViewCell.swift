//
//  ListTableViewCell.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 22/01/2022.
//

import UIKit

final class ListTableViewCell: UITableViewCell {
    
    //MARK: - properties
    @IBOutlet weak var symbolName: UILabel!
    @IBOutlet weak var changePercent: UILabel!
    @IBOutlet weak var last: UILabel!
    
    //MARK: - lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCell()
    }
    
    //MARK: - methods
    private func setupCell () {
        contentView.backgroundColor = .clear
        symbolName.textColor = .systemBlue
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        symbolName.text = nil
        changePercent.text = nil
        last.text = nil
        changePercent.textColor = .label
    }
    
    func configureCell(withSymbol symbol: Symbol) {
        
        if let symbolName = symbol.name {
            self.symbolName.text = symbolName
        } else {
            self.symbolName.text = "nil"
        }
        if let symbolChangePercent = symbol.quote?.changePercent {
            self.changePercent.text = symbolChangePercent.roundedOnTwoDecimals()
            if symbolChangePercent.roundedOnTwoDecimals() != "nil" {
                self.changePercent.text?.append("%")
                if let change = symbol.quote?.change {
                    self.changePercent.textColor = setColorForChange(change: change)
                }
            }
        } else {
            self.changePercent.text = "nil"
        }
        if let symbolLast = symbol.quote?.last {
            self.last.text = symbolLast.roundedOnTwoDecimals()
        } else {
            self.last.text = "nil"
        }
    }
    
    private func setColorForChange(change: String) -> UIColor {
        guard let doubleValue = Double(change) else { return .label }
        if doubleValue > 0 {
            return .systemGreen
        } else if doubleValue < 0 {
            return . red
        } else {
            return .label
        }
    }
    
    
}
