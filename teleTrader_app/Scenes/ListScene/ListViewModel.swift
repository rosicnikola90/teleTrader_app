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

enum StateOfNamesFilter: Int {
    case unsorted = 0
    case ascending
    case descending
}

final class ListViewModel: NSObject {
    
    //MARK: - properties
    weak var delegate: ListViewModelDelegate?
    private var symbols: [Symbol] = []
    private var sortedSymbols: [Symbol] = []
    private var isNamesFilterOn = false
    
    //MARK: - init
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(callFromTimer), name: NSNotification.Name(rawValue:Constants.timerCallNotificationName), object: nil)
    }
    
    deinit {
        print("ListViewModel deinit")
        NotificationCenter.default.removeObserver(self, name: Notification.Name(Constants.timerCallNotificationName), object: nil)
    }
    
    //MARK: - metods
    func getSymbols() {
        DataManager.sharedInstance.getNeededSymbols { [weak self] (symbols, error) in
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
    
    func sortSymbolsAscending() {
        isNamesFilterOn = true
        sortedSymbols = symbols.sorted(by: { $0.name! < $1.name! })
    }
    
    func sortSymbolsDescending() {
        isNamesFilterOn = true
        sortedSymbols = symbols.sorted(by: { $0.name! > $1.name! })
    }
    
    func sortSymbolsToDefault() {
        isNamesFilterOn = false
    }
    
    func returnSymbolDataBasedOnNamesFilter() -> [Symbol] {
        if isNamesFilterOn {
            return sortedSymbols
        } else {
            return symbols
        }
    }
    
    @objc private func callFromTimer() {
        getSymbols()
    }
    
}

// MARK: - extension tableViewDataSource
extension ListViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isNamesFilterOn {
            return sortedSymbols.count
        } else {
            return symbols.count
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            var symbolToDelete = Symbol()
            if isNamesFilterOn {
                symbolToDelete = self.sortedSymbols.remove(at: indexPath.row)
                if let index = symbols.firstIndex(of: symbolToDelete) {
                    symbols.remove(at: index)
                }
            } else {
                symbolToDelete = self.symbols.remove(at: indexPath.row)
                if let index = sortedSymbols.firstIndex(of: symbolToDelete) {
                    sortedSymbols.remove(at: index)
                }
            }
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListTableViewCell
        if isNamesFilterOn {
            cell.configureCell(withSymbol: sortedSymbols[indexPath.row])
        } else {
            cell.configureCell(withSymbol: symbols[indexPath.row])
        }
        return cell
    }
    
}
