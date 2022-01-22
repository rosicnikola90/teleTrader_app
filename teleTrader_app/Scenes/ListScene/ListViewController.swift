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
    
    lazy var viewModel = ListViewModel()
    
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
        filteringView.backgroundColor = .darkGray
        view.backgroundColor = .systemBackground
        title = "List"
        viewModel.delegate = self
    }
    
    private func setupTableView() {
        listTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
        listTableView.delegate = self
        listTableView.dataSource = viewModel
    }
    
}

//MARK: -extension for TableView Delegate
extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



//MARK: -extension for ViewModelDelegate
extension ListViewController: ListViewModelDelegate {
    func symbolsUpdatedWitSuccess() {
        listTableView.reloadData()
    }
    
    func symbolsUpdatedWithError(error: String) {
        
    }
}
