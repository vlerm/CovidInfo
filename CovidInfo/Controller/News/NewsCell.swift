//
//  NewsCell.swift
//  CovidInfo
//
//  Created by Вадим Лавор on 5.10.22.
//

import UIKit

class NewsCell: UICollectionViewCell {
    
    var identifier: String?
    var imageSize: CGSize?
    let imageView = UIImageView()
    let sourceLabel = UILabel()
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let agoLabel = UILabel()
    let lineView = UIView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        agoLabel.attributedText = nil
        agoLabel.text = nil
        contentLabel.text = nil
        contentLabel.attributedText = nil
        identifier = nil
        imageView.image = nil
        sourceLabel.text = nil
        sourceLabel.attributedText = nil
        titleLabel.attributedText = nil
        titleLabel.text = nil
    }
    
    var imageSizeUnwrapped: CGSize {
        guard let unwrappedImageSize = imageSize else { return CGSize.zero }
        return unwrappedImageSize
    }
    
    func configure(_ article: Article) {
        identifier = article.identifier
    }
    
    func update(image: UIImage?, matchingIdentifier: String?) {
        guard identifier == matchingIdentifier else { return }
        imageView.image = image
    }
    
}
