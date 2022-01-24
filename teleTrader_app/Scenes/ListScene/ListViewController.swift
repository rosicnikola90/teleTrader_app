//
//  ListViewController.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 21/01/2022.
//

import UIKit

final class ListViewController: SharedViewController {
    
    //MARK: - properties
    @IBOutlet weak var filteringView: UIView!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var namesButtonLabel: UIButton!
    @IBOutlet weak var upArrowImage: UIImageView!
    @IBOutlet weak var downArrowImage: UIImageView!
    
    lazy private var viewModel = ListViewModel()
    
    private var selectedSymbol: Symbol?
    private var namesPressCount = 0 {
        didSet {
            let moduo = namesPressCount % 3
            print(moduo)
            stateOfNamesFilter = StateOfNamesFilter(rawValue: moduo) ?? .unsorted
        }
    }
    private var stateOfNamesFilter: StateOfNamesFilter = .unsorted {
        didSet {
            switch stateOfNamesFilter {
            case .ascending:
                viewModel.sortSymbolsAscending()
                upArrowImage.tintColor = .systemBlue
                downArrowImage.tintColor = .label
            case .descending:
                viewModel.sortSymbolsDescending()
                upArrowImage.tintColor = .label
                downArrowImage.tintColor = .systemBlue
            case .unsorted:
                viewModel.sortSymbolsToDefault()
                upArrowImage.tintColor = .label
                downArrowImage.tintColor = .label
            }
            listTableView.reloadData()
        }
    }
    
   
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableView()
        viewModel.getSymbols()
    }
    
    //MARK: - init
    deinit {
        print("ListViewController deinit")
    }
    
    //MARK: - setup metodes
    private func setupView() {
        filteringView.backgroundColor = .quaternarySystemFill
        view.backgroundColor = .systemBackground
        title = "List"
        viewModel.delegate = self
    }
    
    private func setupTableView() {
        listTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
        listTableView.delegate = self
        listTableView.dataSource = viewModel
        listTableView.addSubview(refresh)
    }
    
    @IBAction func namesPressed(_ sender: UIButton) {
        namesPressCount += 1
    }
    
    internal override func handleRefresh() {
        viewModel.getSymbols()
        super.handleRefresh()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedSymbol = self.selectedSymbol else { return }
        if segue.identifier == "goToDetails" {
            if let destinationVC = segue.destination as? SymbolDetailsViewController {
                destinationVC.symbol = selectedSymbol
            }
        }
    }
    
}

//MARK: -extension for TableView Delegate
extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let symbolsArray = viewModel.returnSymbolDataBasedOnNamesFilter()
        selectedSymbol = symbolsArray[indexPath.row]
        
        performSegue(withIdentifier: "goToDetails", sender: self)
    }
}



//MARK: -extension for ViewModelDelegate
extension ListViewController: ListViewModelDelegate {
    func symbolsUpdatedWitSuccess() {
        //namesPressCount = 0
        listTableView.reloadData()
    }
    
    func symbolsUpdatedWithError(error: String) {
        showAlert(title: "", message: error)
    }
}

