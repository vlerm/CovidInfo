//
//  TabBarController.swift
//  CovidInfo
//
//  Created by Вадим Лавор on 5.10.22.
//

import UIKit

class TabBarController: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = covidViewControllers
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TabBarController {
    
    var covidViewControllers: [UIViewController] {
        return  [
            informationNavigationController,
            newsNavigationController,
            twitterNavigationController,
        ]
    }
    
    var informationNavigationController: UINavigationController {
        let viewController = InformationViewController(Website.content)
        viewController.tabBarItem.image = UIImage(systemName: TabBar.web.imageSystemName)
        viewController.tabBarItem.title = TabBar.web.name
        let navigationController = UINavigationController(viewController)
        return navigationController
    }
    
    var newsNavigationController: UINavigationController {
        let viewController = NewsViewController(TabBar.news.name)
        viewController.tabBarItem.image = UIImage(systemName: TabBar.news.imageSystemName)
        let navigationController = UINavigationController(viewController)
        return navigationController
    }
    
    var twitterNavigationController: UINavigationController {
        let viewController = TwitterViewController(title: TabBar.twitter.name, usernames: Twitter.content)
        viewController.tabBarItem.image = UIImage(systemName: TabBar.twitter.imageSystemName)
        let navigationController = UINavigationController(viewController)
        return navigationController
    }
    
}

private extension UINavigationController {
    
    convenience init(_ rootViewController: UIViewController, _ prefersLargeTitles: Bool = true) {
        self.init(rootViewController: rootViewController)
        self.navigationBar.prefersLargeTitles = prefersLargeTitles
    }
    
}
