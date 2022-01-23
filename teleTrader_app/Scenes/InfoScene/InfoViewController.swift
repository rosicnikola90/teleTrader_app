//
//  InfoViewController.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 23/01/2022.
//

import UIKit
import PDFKit

final class InfoViewController: UIViewController {
    
    private let pdfView = PDFView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPdfView()
    }
    

    private func setupPdfView() {
        let url = Bundle.main.url(forResource: "Nikola Rosic ios developer CV", withExtension: "pdf")
        view.backgroundColor = .systemBackground
        title = "Developer info"
        view.addSubview(pdfView)
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.maxScaleFactor = 1.2
        pdfView.minScaleFactor = 0.6
        pdfView.backgroundColor = .clear
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        pdfView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: 0).isActive = true
        
        if let url = url {
            guard let document = PDFDocument(url: url) else { return }
            pdfView.document = document
            pdfView.scaleFactor = 0.7
        }
    }

}
