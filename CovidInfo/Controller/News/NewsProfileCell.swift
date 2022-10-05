//
//  NewsProfileCell.swift
//  CovidInfo
//
//  Created by Вадим Лавор on 5.10.22.
//


import UIKit

class NewsProfileCell: NewsCell {
    
    let sourceImageView = UIImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sourceImageView.image = nil
    }
    
    func updateSourceImage(image: UIImage?, matchingIdentifier: String?) {
        guard identifier == matchingIdentifier else { return }
        sourceImageView.image = image
    }
    
}
