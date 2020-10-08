//
//  News.swift
//  NewsApp
//
//  Created by Shaunak Jagtap on 14/09/20.
//  Copyright © 2020 logicPlay. All rights reserved.
//

import Foundation

class News: Codable {
    var title: String
    var url: String
}

class NewsResponse: Codable {
    var hits: [News]
    var nbHits: Int
    var page: Int
    var nbPages: Int
    var hitsPerPage: Int
    var exhaustiveNbHits: Bool
    var query: String
    var params: String
    var processingTimeMS: Int
}
