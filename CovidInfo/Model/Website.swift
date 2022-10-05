//
//  Website.swift
//  CovidInfo
//
//  Created by Вадим Лавор on 5.10.22.
//

import Foundation

struct Website {
    
    var domain: String
    var urlString: String

    static var content: [Website] {
        return [Website(domain: "ncov2019.live", urlString: "https://ncov2019.live")]
    }
    
}
