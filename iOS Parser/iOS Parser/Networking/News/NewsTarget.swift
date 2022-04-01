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
    private let apiKey = "53356b84c5810f900ae1ca29241c5014"

    init(input: String, page: Int, max: Int, dateFrom: Date? = nil, dateTo: Date? = nil) {
        let parameters = ["q": input,
                          "token": apiKey,
                          "page": page,
                          "max": max,
                          "from": dateFrom ?? "",
                          "to": dateTo ?? ""] as [String: Any]
        task = .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
}
