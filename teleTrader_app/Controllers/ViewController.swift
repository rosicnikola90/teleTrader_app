//
//  ViewController.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 21/01/2022.
//

import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("ViewController")
        view.backgroundColor = .green
        RestManager.sharedInstance.getSymbolsFromServer { (stringData, error) in
            
        }
    }


}

