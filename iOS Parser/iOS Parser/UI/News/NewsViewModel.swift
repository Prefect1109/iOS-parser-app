//
//  NewsViewModel.swift
//  iOS Parser
//
//  Created by Prefect on 23.03.2022.
//

import RxSwift
import Moya
import RxCocoa
import Darwin

class NewsViewModel: ViewModelType {
    struct Input {
        var featchMore: Observable<Void>
        var refreshControlEvent: Observable<Void>
    }
    
    struct Output {
        var items: Driver<[SearchTableViewSection]>
        var isLoadingSpinnerAvaliable: Observable<Bool>
        var refreshControlCompelted: Observable<Void>
    }
    
    struct Dependencies {}
    
    private let newsService = NewsService()
    private let disposeBag = DisposeBag()
    private let inputString = PublishSubject<String>()
    private let items = PublishSubject<[SearchTableViewSection]>()
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(_ input: Input) -> Output {
        let newsServiceOuput = newsService.transform(.init(inputString: inputString.asObservable(),
                                                           featchMore: input.featchMore,
                                                           refreshControlEvent: input.refreshControlEvent,
                                                           dateFrom: .never(),
                                                           dateTo: .never()))

        inputString.onNext("test")
        
        let newsDriver: Driver<[SearchTableViewSection]> = newsServiceOuput.articles
            .asDriver(onErrorDriveWith: .never())
            .map { articles -> [SearchTableViewSection] in
                var articleItems: [SearchTableViewItem] = []
                
                for (index, article) in articles.enumerated() {
                    if index == 0 {
                        articleItems = [.news(article: article)]
                    } else {
                        articleItems.append(.news(article: article))
                    }
                }
                return [.news(items: articleItems)]
            }

        newsDriver
            .drive(items)
            .disposed(by: disposeBag)
        
        return .init(items: items.asDriver(onErrorDriveWith: .never()),
                     isLoadingSpinnerAvaliable: newsServiceOuput.isLoadingSpinnerAvaliable,
                     refreshControlCompelted: newsServiceOuput.refreshControlCompelted)
    }
}
