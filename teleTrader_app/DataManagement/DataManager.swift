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
    
    
    
}
