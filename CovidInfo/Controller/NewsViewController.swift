//
//  NewsViewController.swift
//  CovidInfo
//
//  Created by Вадим Лавор on 5.10.22.
//

import UIKit
import SafariServices

class NewsViewController: UIViewController {
    
    private let refreshControl = UIRefreshControl()
    private let apiKey = "8815d577462a4195a64f6f50af3ada08"
    private var collectionView: UICollectionView?
    private var articles: [Article] = []
    private var imageCache: [String: UIImage] = [:]
    private var imageDownloader = ImageDownloader()
    
    init(_ stringTitle: String) {
        super.init(nibName: nil, bundle:nil)
        title = stringTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureView()
        loadData()
    }
}

private extension NewsViewController {
    
    func setupView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: genericLayout())
        collectionView?.register(FlipboardCell.self, forCellWithReuseIdentifier: FlipboardCell.reuseIdentifier)
        collectionView?.backgroundColor = .systemBackground
        collectionView?.dataSource = self
        collectionView?.delegate = self
        refreshControl.addTarget(self, action: #selector(loadData), for: UIControl.Event.valueChanged)
    }
    
    func configureView() {
        collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let collectionView = collectionView {
            view.addSubview(collectionView)
        }
        collectionView?.addSubview(refreshControl)
    }
    
    func genericLayout() -> UICollectionViewLayout {
        let section = NSCollectionLayoutSection(group: NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(400)
        ), subitem: NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(400)
        )), count: 1))
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    @objc func loadData() {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)&category=health") else {
            self.presentAlertControllerWithMessage("Error with the News API URL")
            return
        }
        self.articles = []
        self.collectionView?.reloadData()
        url.get { (result: Result<Headline,ApiError>) in
            self.refreshControl.endRefreshing()
            switch result {
            case .success(let headline):
                self.articles = headline.articles
                self.collectionView?.reloadData()
            case .failure(let e):
                self.presentAlertControllerWithMessage(e.localizedDescription)
            }
        }
    }
    
}

extension NewsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlipboardCell.reuseIdentifier, for: indexPath) as! FlipboardCell
        let article = self.articles[indexPath.row]
        let identifier = article.identifier
        cell.configure(article)
        imageDownloader.getImage(imageUrl: article.urlToImage, size: cell.imageSizeUnwrapped) { (image) in
            guard cell.identifier == identifier else { return }
            cell.update(image: image, matchingIdentifier: identifier)
        }
        imageDownloader.getImage(imageUrl: article.urlToSourceLogo, size: FlipboardCell.logoSize) { (image) in
            cell.updateSourceImage(image: image, matchingIdentifier: identifier)
        }
        return cell
    }
}

extension NewsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        guard let url = article.url else { return }
        let safariViewContoller = SFSafariViewController(url: url)
        self.present(safariViewContoller, animated: true, completion: nil)
    }
    
}
