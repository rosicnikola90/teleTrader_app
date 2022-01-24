//
//  NewsTableViewCell.swift
//  teleTrader_app
//
//  Created by Nikola Rosic on 23/01/2022.
//

import UIKit

final class NewsTableViewCell: UITableViewCell {

    //MARK: - properties
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsHeadline: UILabel!
    @IBOutlet weak var agoInfo: UILabel!
    
    var newsId = ""
    
    //MARK: - lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCell()
    }
    //MARK: - metods
    private func setupCell () {
        contentView.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        newsImage.image = UIImage(systemName: "filemenu.and.selection")
        newsHeadline.text = nil
        agoInfo.text = nil
        newsId = ""
    }
    
    func configureCell(withNewsInfo news: News) {
        
        if let headline = news.headline {
            newsHeadline.text = headline
        }
        if let timeAgo = news.dateTime {
            if let date = DateManager.shared.toDate(from: timeAgo) {
                agoInfo.text = date.timeAgoDisplay()
            }
        }
        
        if let tag = news.tags.filter({ $0.position == "0" }).first {
            if let imageCode = tag.picTT?.imageID {
                self.newsId = imageCode
                DataManager.sharedInstance.getNewsImageData(forCode: imageCode, andSize: .small) { [weak self] (data, error, id) in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        if let data = data {
                            if let imageNew = UIImage(data: data) {
                                if let id = id {
                                    if id == self.newsId {
                                        self.newsImage.image = imageNew
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
