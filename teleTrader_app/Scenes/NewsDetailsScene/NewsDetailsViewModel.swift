//
//  NewsDetailsViewModel.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 23/01/2022.
//

import UIKit


protocol NewsDetailsViewModelDelegate: class {
    func newsImageUpdatedWitSuccess(images: [String : UIImage])
}

final class NewsDetailsViewModel: NSObject {
    
    //MARK: - properties
    weak var delegate: NewsDetailsViewModelDelegate?
    private var images: [String : UIImage] = [:]
    
    //MARK: - init
    deinit {
        print("NewsDetailsViewModel deinit")
    }
    
    //MARK: - metods
    
    func getImages(for news: News) {
        getImage(forNews: news, size: .medium) {
            self.delegate?.newsImageUpdatedWitSuccess(images: self.images)
            self.getImage(forNews: news, size: .large) {
                self.delegate?.newsImageUpdatedWitSuccess(images: self.images)
            }
        }
    }
    
    func returnImage(forSize size: NewsImageSize) -> UIImage? {
        let key = size.rawValue
        if let image = images[key] {
            return image
        } else {
            return nil
        }
    }
    
    private func getImage(forNews news: News, size: NewsImageSize, completion: @escaping() -> ()) {
        if let tag = news.tags.filter({ $0.position == "0" }).first {
            if let imageCode = tag.picTT?.imageID {
                DataManager.sharedInstance.getNewsImageData(forCode: imageCode, andSize: size) { [weak self] (data, error, id) in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        if let data = data {
                            if let imageNew = UIImage(data: data) {
                                let key = size.rawValue
                                self.images[key] = imageNew
                                completion()
                            }
                        }
                    }
                }
            }
        }
    }
}
