//
//  Extensions.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 22/01/2022.
//

import UIKit

extension String {
    
    func roundedOnTwoDecimals() -> String? {
        guard let doubleValue = Double(self) else { return "nil" }
        return String(format: "%.2f", doubleValue)
    }
}

extension UIViewController {
    
    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
}
