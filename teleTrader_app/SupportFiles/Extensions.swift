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
    
    static let activityIndicator = UIActivityIndicatorView()
    
    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
    
    func startLoading() {
        let activityIndicator = UIViewController.activityIndicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.systemBlue
        activityIndicator.style = UIActivityIndicatorView.Style.large

        DispatchQueue.main.async {
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
    }
    
    func stopLoading() {
        let activityIndicator = UIViewController.activityIndicator
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
}

extension Date {
    
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
