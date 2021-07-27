//
//  Helper.swift
//  HW_37.7
//
//  Created by Mykhailo Romanovskyi on 16.06.2021.
//

import Foundation

let urlString = "https://newsapi.org/v2/top-headlines?country=us&apiKey=549aa53a47b24437adcc04e0c50a7d78"
typealias GetComplete = ()->()

struct NewsModel: Codable {
    let totalResults: Int?
    let articles: [Artical]?
    
    struct Artical: Codable {
        let title: String?
        let urlToImage: String?
        var imageData: Data?
    }
}

