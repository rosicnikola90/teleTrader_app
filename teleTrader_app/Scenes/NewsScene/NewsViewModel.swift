//
//  NewsViewModel.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 23/01/2022.
//

import UIKit


protocol NewsViewModelDelegate: class {
    func newsUpdatedWitSuccess()
    func newsUpdatedWithError(error: String)
}

final class NewsViewModel: NSObject {
    
    //MARK: - properties
    weak var delegate: NewsViewModelDelegate?
    private var newsArray: [News] = []
    
    
    //MARK: - init
    deinit {
        print("NewsViewModel deinit")
    }
    
    //MARK: - metods
    func getNews() {
        DataManager.sharedInstance.getNeededNews { [weak self] (news, error) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.delegate?.newsUpdatedWithError(error: error)
                } else if let news = news {
                    self.newsArray = news
                    self.delegate?.newsUpdatedWitSuccess()
                } else {
                    self.delegate?.newsUpdatedWithError(error: error ?? "something went wrong")
                }
            }
        }
    }
    
}

// MARK: - extension tableViewDataSource
extension NewsViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        let actualNews = newsArray[indexPath.row]
        cell.configureCell(withNewsInfo: actualNews)
        return cell
    }
    
    
}

