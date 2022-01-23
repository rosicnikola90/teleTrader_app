//
//  SharedViewController.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 23/01/2022.
//

import UIKit

class SharedViewController: UIViewController {
    
     let refresh: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .label
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    @objc func handleRefresh() {
        refresh.endRefreshing()
    }
}
