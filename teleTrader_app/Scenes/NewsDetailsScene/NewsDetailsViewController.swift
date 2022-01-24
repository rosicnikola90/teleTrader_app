//
//  NewsDetailsViewController.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 23/01/2022.
//

import UIKit

final class NewsDetailsViewController: UIViewController, RotatableViewController, NewsDetailsViewModelDelegate {
    
    
    //MARK: - properties
    var news: News?
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var headlineLabelTop: UILabel!
    @IBOutlet weak var headlineLabelBottom: UILabel!
    private let viewModel = NewsDetailsViewModel()
    
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        guard let news = news else { return }
        viewModel.getImages(for: news)
    }
    
    deinit {
        print("NewsDetailsViewController deinit")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //prevent previous vc to rotate
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    //MARK: - methods
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            if let image = viewModel.returnImage(forSize: .large) {
                newsImageView.image = image
            }
        } else {
            print("Portrait")
            if let image = viewModel.returnImage(forSize: .medium) {
                newsImageView.image = image
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "News detail"
        viewModel.delegate = self
        headlineLabelTop.text = news?.headline
        headlineLabelBottom.text = news?.headline
    }
    
    func newsImageUpdatedWitSuccess(images: [String : UIImage]) {
        let key = NewsImageSize.medium.rawValue
        if let image = images[key] {
            newsImageView.image = image
        }
    }
}


