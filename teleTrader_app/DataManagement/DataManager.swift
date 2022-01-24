//
//  DataManager.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 21/01/2022.
//

import UIKit
import Foundation
import CoreData


final class DataManager {
    
    //MARK: - properties
    public static let sharedInstance = DataManager()
    private let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var randomDouble = 0.0 {
        willSet {
            previousRandom = newValue
        }
    }
    private var previousRandom = 0.0
    private var isAppJustStarted = true {
        willSet {
            if newValue != isAppJustStarted {
                makeRandomDouble(previous: previousRandom)
                fireAPICalls(withDelay: randomDouble)
            }
        }
    }
    private var xmls:[XMLLocalData]? = nil
    
    //MARK: - init
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(xmlStringHasUpdated(notification:)), name: Notification.Name(Constants.xmlStringNotification), object: nil)
    }
    
    deinit {
        print("DataManager deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - methods
    func getNeededSymbols(_ completion: @escaping([Symbol]?, String?) -> ()) {
        if isAppJustStarted {
            if let symbols = loadSymbolsFromLocal() {
                isAppJustStarted = false
                completion(symbols, nil)
            } else {
                RestManager.sharedInstance.getSymbolsFromServer { (symbols, error) in
                    
                    if let error = error {
                        completion(nil, error)
                    } else {
                        if let symbols = symbols {
                            self.isAppJustStarted = false
                            completion(symbols, nil)
                        } else {
                            completion(nil, "something went wrong")
                        }
                    }
                }
            }
        } else {
            RestManager.sharedInstance.getSymbolsFromServer { (symbols, error) in
                if let error = error {
                    completion(nil, error)
                } else {
                    if let symbols = symbols {
                        self.isAppJustStarted = false
                        completion(symbols, nil)
                    } else {
                        completion(nil, "something went wrong")
                    }
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
    
    func getNewsImageData(forCode code: String, andSize size: NewsImageSize, _ completion: @escaping(Data?, String?, String?) -> ()) {
        RestManager.sharedInstance.getImageData(forImageCode: code, withSize: size) { (data, error, id) in
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
    
    @objc private func xmlStringHasUpdated(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        if let string = userInfo["xmlString"] as? String {
            if saveXMLStringToCD(stringXML: string) {
                print("SAVED TO CD !")
            }
        }
    }
    
    private func makeRandomDouble(previous: Double) {
        if previous == 0.0 {
            randomDouble = Double.random(min: Constants.rangeForTimerMin, max: Constants.rangeForTimerMax)
            previousRandom = randomDouble
            print("FIRST RANDOM \(randomDouble)")
        } else {
            print("OLD RANDOM: \(previous)")
            let range = 20 * previous / 100 // range of 20% of last value
            var min = previous - range
            if min < Constants.rangeForTimerMin {
                min = Constants.rangeForTimerMin
            }
            var max = previous + range
            if max > Constants.rangeForTimerMax {
                max = Constants.rangeForTimerMax
            }
            randomDouble = Double.random(min: min, max: max)
            print("NEW RANDOM: \(randomDouble)")
        }
    }
    
    private func fireAPICalls(withDelay delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.timerCallNotificationName), object: nil, userInfo: nil)
            self.makeRandomDouble(previous: self.previousRandom)
            self.fireAPICalls(withDelay: self.randomDouble)
        })
    }
    
    //MARK: - local data
    private func loadSymbolsFromLocal() -> [Symbol]? {
        if let stringXML = loadSymbolsXMLFromCD() {
            let parser = NRXMLParser(withXML: stringXML, forXMLType: .symbol)
            return parser.parseSymbols()
        } else {
            return nil
        }
    }
    
    private func loadSymbolsXMLFromCD() -> String? {
        let request:NSFetchRequest<XMLLocalData> = XMLLocalData.fetchRequest()
        do { xmls = try managedContext.fetch(request)
            print("loaded")
            if xmls != nil {
                return xmls?.first?.xmlString
            } else {
                return nil
            }
        }
        catch { print(error.localizedDescription); return nil }
    }
    
    private func saveXMLStringToCD(stringXML: String) -> Bool {
        if let xmls = xmls {
            if xmls.count > 0 {
                managedContext.delete(xmls.first!)
            }
        }
        
        let xmlData = XMLLocalData(context:managedContext)
        xmlData.xmlString = stringXML
        do {
            try managedContext.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
}
