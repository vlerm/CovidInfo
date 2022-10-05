//
//  TabBar.swift
//  CovidInfo
//
//  Created by Вадим Лавор on 5.10.22.
//

import Foundation

struct TabBar {
    static let web = Info(name: "Information", imageSystemName: "globe")
    static let news = Info(name: "News", imageSystemName: "dot.radiowaves.left.and.right")
    static let twitter = Info(name: "Twitter", imageSystemName: "bolt")
}

extension TabBar {
    
    struct Info {
        var name: String
        var imageSystemName: String
    }
    
}
