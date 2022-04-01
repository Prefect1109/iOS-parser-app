//
//  NewsResponse.swift
//  iOS Parser
//
//  Created by Prefect on 01.04.2022.
//

import Foundation

struct NewsResponse: Codable {
    let totalArticles: Int
    let articles: [Article]
}
