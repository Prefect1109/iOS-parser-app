//
//  NewsTarget.swift
//  iOS Parser
//
//  Created by Prefect on 28.03.2022.
//

import Moya

class NewsTarget: TargetType {
    
    var baseURL: URL {
        URL(string: "https://gnews.io/api/v4")!
    }
    
    var path: String {
        "/search"
    }
    
    var method: Method {
        .get
    }
    
    var sampleData: Data {
        Data()
    }
    var headers: [String : String]?

        
    public var task: Task
    private let apiKey = "7775dcab2034e29fb8924262de15c7ef"
    
    init(input: String, page: Int, max: Int) {
        let parameters = ["q": input, "token": apiKey, "page": page, "max": max] as [String: Any]
        task = .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
}
