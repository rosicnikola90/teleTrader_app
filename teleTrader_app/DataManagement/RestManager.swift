//
//  RestManager.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 21/01/2022.
//

import Foundation

enum NewsImageSize: String {
    case small = "small"
    case medium = "medium"
    case large = "large"
}

final class RestManager {
    
    //MARK: - properties
    public static let sharedInstance = RestManager()
    private var session: URLSession
    private var imageDataForNews = NSCache <NSString, NSData>()
    
    //MARK: - init
    private init() {
        let config = URLSessionConfiguration.default
        let userPasswordString = Constants.userNameForHeader + ":" + Constants.passwordForHeader
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        let base64EncodedCredential = userPasswordData!.base64EncodedString()
        let authString = "Basic \(base64EncodedCredential)"
        config.httpAdditionalHeaders = ["Authorization" : authString]
        let session = URLSession(configuration: config)
        self.session = session
    }
    
    deinit {
        print("RestManager deinit")
    }
    
    //MARK: - get methods
    func getSymbolsFromServer(_ completion: @escaping([Symbol]?, String?) -> ()) {
        guard let url = URL(string: Constants.urlForSymbolList) else { completion(nil, "URL error"); return }
        
        print("getSymbolsFromServer URL: \(url)")
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
                if let data = data, httpResponse.statusCode == 200 {
                    if let string = String(data: data, encoding: .utf8) {
                        let parser = NRXMLParser(withXML: string, forXMLType: .symbol)
                        let arrayOfSymbols = parser.parseSymbols()
                        print("getSymbolsFromServer success count: \(arrayOfSymbols.count)")
                        completion(arrayOfSymbols, nil)
                    }
                } else {
                    completion(nil, error?.localizedDescription ?? "error with data")
                }
            } else {
                completion(nil, error?.localizedDescription ?? "no response")
            }
        })
        task.resume()
    }
    
    func getNewsFromServer(_ completion: @escaping([News]?, String?) -> ()) {
        guard let url = URL(string: Constants.urlForNewsList) else { completion(nil, "URL error"); return }
        
        print("getSymbolsFromServer URL: \(url)")
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription)
                }
                if let data = data, httpResponse.statusCode == 200 {
                    if let string = String(data: data, encoding: .utf8) {
                        let newString = string.replacingOccurrences(of: "\\", with: "")
                        let parser = NRXMLParser(withXML: newString, forXMLType: .news)
                        let arrayOfNews = parser.parseNews()
                        print("getNewsFromServer success count: \(arrayOfNews.count)")
                        completion(arrayOfNews, nil)
                    }
                } else {
                    completion(nil, error?.localizedDescription ?? "error with data")
                }
            } else {
                completion(nil, error?.localizedDescription ?? "no response")
            }
        })
        task.resume()
    }
    
    func getImageData(forImageCode code: String, withSize size: NewsImageSize, _ completion: @escaping(Data?, String?, String?) -> ()) {
        
        
        var urlString = Constants.prefixForURLToNewsImage + code + Constants.sufixForURLToNewsImage
        switch size {
        case .small:
            urlString += Constants.sizeSufixSmall
            if let imageData = imageDataForNews.object(forKey: NSString(string: code)) {
                completion(imageData as Data, nil, code)
                return
            }
        case .medium:
            urlString += Constants.sizeSufixMedium
        case .large:
            urlString += Constants.sizeSufixLarge
        }
        guard let url = URL(string: urlString) else { completion(nil, "URL error", nil); return }
        print("getSymbolsFromServer URL: \(url)")
        let task = session.downloadTask(with: url) {
            (localURL, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil, error.localizedDescription, nil)
                }
                if let localURL = localURL, httpResponse.statusCode == 200 {
                    do {
                        let data = try Data(contentsOf: localURL)
                        self.imageDataForNews.setObject(data as NSData, forKey: NSString(string: code))
                        completion(data, nil, code)
                    } catch let error {
                        completion(nil, error.localizedDescription, nil)
                    }
                } else {
                    completion(nil, error?.localizedDescription ?? "error with data", nil)
                }
            } else {
                completion(nil, error?.localizedDescription ?? "no response", nil)
            }
        }
        task.resume()
    }
}
