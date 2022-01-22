//
//  RestManager.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 21/01/2022.
//

import Foundation

final class RestManager {
    
    //MARK: - properties
    public static let sharedInstance = RestManager()
    private var session: URLSession
    
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
    
    //MARK: - get methods
    func getSymbolsFromServer(_ completion: @escaping(String?, String?) -> ()) {
        guard let url = URL(string: Constants.urlForSymbolList) else { completion(nil, "URL error"); return }
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            }
            if let data = data {
                let string = String(data: data, encoding: .utf8)
                print(string ?? "")
            }
        })
        task.resume()
    }
}
