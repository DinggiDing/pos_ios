//
//  Article.swift
//  MVVM
//
//  Created by 성재 on 2021/12/31.
//

import Foundation

struct ArticleList: Decodable {
    let articles: [Article]
    
}

struct Article: Decodable {
    let title: String?
    let description: String?
}
