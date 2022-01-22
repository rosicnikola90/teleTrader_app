//
//  ListViewModel.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 22/01/2022.
//

import UIKit

protocol ListViewModelDelegate: class {
    func symbolsUpdatedWitSuccess()
    func symbolsUpdatedWithError(error: String)
}

final class ListViewModel: NSObject {
    
    //MARK: - properties
    weak var delegate: ListViewModelDelegate?
    private var symbols: [Symbol] = [] {
        didSet {
            // reload data
        }
    }
    
    //MARK: - init
    deinit {
        print("ListViewModel deinit")
    }
    
    //MARK: - metods
    func getSymbols() {
        DataManager.sharedInstance.getNeededSymbols {[weak self] (symbols, error) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.delegate?.symbolsUpdatedWithError(error: error)
                } else if let symbols = symbols {
                    self.symbols = symbols
                    self.delegate?.symbolsUpdatedWitSuccess()
                } else {
                    self.delegate?.symbolsUpdatedWithError(error: error ?? "something went wrong")
                }
            }
        }
    }
    
}

// MARK: - extension
extension ListViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symbols.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            //proveriti filter
            self.symbols.remove(at: indexPath.row)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListTableViewCell
        cell.configureCell(withSymbol: symbols[indexPath.row])
        return cell
    }
    
    
}
