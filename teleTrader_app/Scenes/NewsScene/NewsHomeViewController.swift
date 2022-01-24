//
//  NewsHomeViewController.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 21/01/2022.
//

import UIKit

final class NewsHomeViewController: SharedViewController {

    //MARK: - properties
    private lazy var viewModel = NewsViewModel()
    @IBOutlet weak var newsTableView: UITableView!
    private var selectedNews: News?
    private let segueName = "goToNewsDetails"
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableView()
        startLoading()
        viewModel.getNews()
    }
    
    //MARK: - methods
    private func setupTableView() {
        newsTableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        newsTableView.delegate = self
        newsTableView.dataSource = viewModel
        newsTableView.addSubview(refresh)
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "News"
        viewModel.delegate = self
    }

    override func handleRefresh() {
        viewModel.getNews()
        super.handleRefresh()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedNews = self.selectedNews else { return }
        if segue.identifier == segueName {
            if let destinationVC = segue.destination as? NewsDetailsViewController {
                destinationVC.news = selectedNews
            }
        }
    }
}

//MARK: -extension for ViewModelDelegate
extension NewsHomeViewController: NewsViewModelDelegate {
    func newsUpdatedWitSuccess() {
        stopLoading()
        newsTableView.reloadData()
    }
    
    func newsUpdatedWithError(error: String) {
        stopLoading()
        showAlert(title: "", message: error)
    }
}

//MARK: -extension for TableView Delegate
extension NewsHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedNews = viewModel.returnSelectedNews(forIndexPath: indexPath)
        performSegue(withIdentifier: segueName, sender: self)
    }
}
