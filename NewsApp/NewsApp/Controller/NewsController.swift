//
//  NewsController.swift
//  NewsApp
//
//  Created by Shaunak Jagtap on 14/09/20.
//  Copyright © 2020 logicPlay. All rights reserved.
//

import Foundation

class NewsController {
    static let shared = NewsController()
    private init () {}

    typealias suceess = ([News]) -> Void
    typealias failure = (Error) -> Void

    func searchNews (query: String, success: @escaping suceess, failure: @escaping failure) {
        let Url = String(format: "\(NewsConstants.Strings.queryURL)\(query)")
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = nil

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let news:NewsResponse = try decoder.decode(NewsResponse.self, from: data)
                    success(news.hits)
                } catch {
                    failure(error)
                }
            }

            if let error = error {
                failure(error)
            }
            
            }.resume()
    }
}
