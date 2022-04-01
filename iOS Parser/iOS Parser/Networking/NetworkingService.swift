//
//  NetworkingService.swift
//  iOS Parser
//
//  Created by Prefect on 31.03.2022.
//

import RxSwift
import Moya

class NetworkingService {
    
    private init() { }
    
    static var shared = NetworkingService()
    
    private let provider = MoyaProvider<MultiTarget>()
    private let jsonDecoder = JSONDecoder()
    private var requests: [Cancellable] = []
    
    func createSingle<T: Decodable>(target: TargetType) -> Single<T> {
        
        let decoder = jsonDecoder
        let moyaProvider = provider
        
        return Single.create { single -> Disposable in
            let cancellable = moyaProvider.request(MultiTarget(target), completion: { result in
                switch result {
                case .success(let response):
                    do {
                        if T.self == String.self {
                            let string = try response.mapString()
                            single(.success(string as! T))
                        } else if T.self == Data.self {
                            single(.success(response.data as! T))
                        } else {
                            let decoded = try response.map(T.self, using: decoder)
                            single(.success(decoded))
                        }
                    }
                    catch {
                        single(.failure(error))
                    }
                case .failure(let error):
                    single(.failure(error))
                }
            })
            self.requests.append(cancellable)
            
            return Disposables.create {
                cancellable.cancel()
                self.cleanRequests()
            }
        }
    }
    
    private func cleanRequests() {
        requests.enumerated().forEach { request in
            if request.element.isCancelled {
                requests.remove(at: request.offset)
            }
        }
    }
    
    func cancelRequests() {
        requests.forEach { cancellable in cancellable.cancel() }
        requests.removeAll()
    }
}
