//
//  FlipboardCell.swift
//  CovidInfo
//
//  Created by Вадим Лавор on 5.10.22.
//

import UIKit

class FlipboardCell: NewsProfileCell {
    
    static let reuseIdentifier = "flipboard"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configurateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure(_ article: Article) {
        super.configure(article)
        titleLabel.text = article.title
        contentLabel.attributedText = article.flipboardAttributedSubtitle
        agoLabel.text = article.publishedAt?.timeAgoSinceDate
        sourceLabel.text = article.source?.name
    }
    
}

private extension Date {
    
    var timeAgoSinceDate: String {
        let fromDate = self
        let toDate = Date()
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }
        return "a moment ago"
    }
    
}

extension FlipboardCell {
    
    static var logoSize = CGSize(width: 38, height: 38)
    
    func setupView() {
        imageSize = CGSize(width: 400, height: 240)
        lineView.backgroundColor = .flipboardLineGray
        contentView.backgroundColor = .flipboardWhite
        contentLabel.numberOfLines = 0
        imageView.contentMode = .scaleAspectFit
        sourceLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 17)
        agoLabel.textColor = .flipboardAgoGray
        agoLabel.font = .systemFont(ofSize: 14)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 28)
        sourceImageView.layer.cornerRadius = FlipboardCell.logoSize.width / 2
        sourceImageView.layer.masksToBounds = true
    }
    
    func configurateView() {
        [lineView, imageView, titleLabel, contentLabel, sourceImageView, sourceLabel, agoLabel].forEach { contentView.autolayoutAddSubview($0) }
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: contentView.topAnchor),
            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 13),
            imageView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            contentView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            imageView.heightAnchor.constraint(equalToConstant: imageSizeUnwrapped.height),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            contentLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            sourceImageView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 15),
            sourceImageView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            sourceImageView.widthAnchor.constraint(equalToConstant: FlipboardCell.logoSize.width),
            sourceImageView.heightAnchor.constraint(equalToConstant: FlipboardCell.logoSize.width),
            sourceLabel.leadingAnchor.constraint(equalTo: sourceImageView.trailingAnchor, constant: 10),
            sourceLabel.centerYAnchor.constraint(equalTo: sourceImageView.centerYAnchor),
            agoLabel.topAnchor.constraint(equalTo: sourceImageView.bottomAnchor, constant: 22),
            agoLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: agoLabel.bottomAnchor, constant: 5),
        ])
    }
    
}

private extension Article {
    
    var flipboardAttributedSubtitle: NSAttributedString {
        guard
            let font = UIFont(name: "AppleSDGothicNeo-Light", size: 15),
            let d = descriptionOrContent else { return NSAttributedString() }
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.2
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: style,
        ]
        return NSAttributedString.init(string: d, attributes: attributes)
    }
    
}

private extension UIColor {
    
    static let flipboardAgoGray = UIColor.colorFor(red: 171, green: 173, blue: 174)
    static let flipboardRed = UIColor.colorFor(red: 242, green: 38, blue: 38)
    
    static var flipboardWhite: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return .systemBackground
            } else {
                return UIColor.colorFor(red: 254, green: 255, blue: 255)
            }
        }
    }
    
    static var flipboardLineGray: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor.colorFor(red: 60, green: 60, blue: 60)
            } else {
                return UIColor.colorFor(red: 231, green: 232, blue: 233)
            }
        }
    }
    
}
