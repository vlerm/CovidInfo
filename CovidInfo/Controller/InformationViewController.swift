//
//  InformationViewController.swift
//  CovidInfo
//
//  Created by Вадим Лавор on 5.10.22.
//

import UIKit
import WebKit

class InformationViewController: UIViewController {
    
    private var webView = WKWebView()
    private var activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    var websites: [Website] = []
    
    init(_ sites: [Website]) {
        super.init(nibName: nil, bundle:nil)
        websites = sites
        setupView()
        configureView()
        loadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension InformationViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if webView.estimatedProgress == 1 {
                activityIndicatorView.stopAnimating()
            }
        }
    }
    
}

private extension InformationViewController {
    
    func loadWebsite(_ website: Website) {
        guard let url = URL(string: website.urlString) else { return }
        activityIndicatorView.startAnimating()
        webView.evaluateJavaScript("document.body.remove()")
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func setupView() {
        title = TabBar.web.name
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    private func configureView() {
        view = webView
        let children: [UIAction] = websites.map {
            let param = $0
            return UIAction(title: $0.domain) { _ in
                self.loadWebsite(param)
            }
        }
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), primaryAction: nil, menu: UIMenu(title: String(), children: children))
        navigationItem.rightBarButtonItems = [barButtonItem]
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func loadData() {
        if let website = websites.first {
            loadWebsite(website)
        }
    }
    
}
