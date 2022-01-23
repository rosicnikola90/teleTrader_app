//
//  DataManager.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 21/01/2022.
//

import Foundation
import CoreData


final class DataManager {
    
    //MARK: - properties
    public static let sharedInstance = DataManager()
    private(set) var managedContext: NSManagedObjectContext!
    private var defaults: UserDefaults {
        get { return .standard }
    }
    
    //MARK: - init
    private init() {}
    
    deinit {
        print("DataManager deinit")
    }
    
    //MARK: - methods
    func getNeededSymbols(_ completion: @escaping([Symbol]?, String?) -> ()) {
        // proveriti odakle se povlace podaci pa dovuci
        
        RestManager.sharedInstance.getSymbolsFromServer { (symbols, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let symbols = symbols {
                    completion(symbols, nil)
                } else {
                    completion(nil, "something went wrong")
                }
            }
        }
    }
    
    func getNeededNews(_ completion: @escaping([News]?, String?) -> ()) {
        RestManager.sharedInstance.getNewsFromServer { (news, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let news = news {
                    completion(news, nil)
                } else {
                    completion(nil, "something went wrong")
                }
            }
        }
    }
    
    func getNewsImageData(forCode code: String, _ completion: @escaping(Data?, String?, String?) -> ()) {
        
        RestManager.sharedInstance.getImageData(forImageCode: code) { (data, error, id) in
            if error != nil {
                completion(nil, error, nil)
            } else {
                if let data = data {
                    
                    completion(data, nil , id)
                } else {
                    completion(nil, error, nil)
                }
            }
        }
    }
}
