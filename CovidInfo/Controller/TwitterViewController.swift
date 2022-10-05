//
//  TwitterViewController.swift
//  CovidInfo
//
//  Created by Вадим Лавор on 5.10.22.
//

import UIKit
import WebKit
import SafariServices

class TwitterViewController: UIViewController {
    
    private let webView = WKWebView()
    private let refreshControl = UIRefreshControl()
    
    var users: [String] = []
    var webContentDescription = String()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, usernames: [String]) {
        super.init(nibName: nil, bundle:nil)
        users = usernames
        setupView(titleView: title, user: usernames.first)
        configureView()
        refreshWebView(user: usernames.first)
    }
}

private extension TwitterViewController {
    
    func getWebDescriptionForUser(_ user: String?) -> String {
        guard let user = user else { return String() }
        return """
        <meta name='viewport' content='initial-scale=1.0'/>
        <a class="twitter-timeline" href="https://twitter.com/\(user)"></a>
        <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
        """
    }
    
    func setupView(titleView: String, user: String?) {
        view.backgroundColor = .white
        title = titleView
        webView.navigationDelegate = self
    }
    
    func configureView() {
        view.autolayoutAddSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
            webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        refreshControl.addTarget(self, action: #selector(refreshWebView(_:)), for: UIControl.Event.valueChanged)
        webView.scrollView.addSubview(refreshControl)
        webView.scrollView.bounces = true
        let children: [UIAction] = users.map {
            let user = $0
            let title = "@" + $0
            return UIAction(title: title) { _ in
                self.refreshWebView(user: user)
            }
        }
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "ellipsis"), primaryAction: nil, menu: UIMenu(title: String(), children: children))]
    }
    
    func refreshWebView(user: String?) {
        webContentDescription = getWebDescriptionForUser(user)
        webView.loadHTMLString(webContentDescription, baseURL: nil)
    }
    
    @objc func refreshWebView(_ sender: UIRefreshControl) {
        webView.loadHTMLString(webContentDescription, baseURL: nil)
        sender.endRefreshing()
    }
    
}

extension TwitterViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url {
                let safariViewController = SFSafariViewController(url: url)
                self.present(safariViewController, animated: true, completion: nil)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
    
}
