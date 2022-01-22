//
//  ListViewController.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 21/01/2022.
//

import UIKit

final class ListViewController: UIViewController {
    
    //MARK: - properties
    @IBOutlet weak var filteringView: UIView!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var namesButtonLabel: UIButton!
    @IBOutlet weak var upArrowImage: UIImageView!
    @IBOutlet weak var downArrowImage: UIImageView!
    
    lazy var viewModel = ListViewModel()
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
    }
    
    @IBAction func namesPressed(_ sender: UIButton) {
        namesPressCount += 1
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
    }
}



//MARK: -extension for ViewModelDelegate
extension ListViewController: ListViewModelDelegate {
    func symbolsUpdatedWitSuccess() {
        namesPressCount = 0
    }
    
    func symbolsUpdatedWithError(error: String) {
        
    }
}

