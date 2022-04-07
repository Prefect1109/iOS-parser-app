//
//  SearchViewModel.swift
//  iOS Parser
//
//  Created by Prefect on 27.03.2022.
//

import RxSwift
import RxCocoa

class SearchViewModel: ViewModelType {
    struct Input {
        var inputString: Observable<String>
        var featchMore: Observable<Void>
        var refreshControlEvent: Observable<Void>
    }
    
    struct Output {
        var tableHeaderValue: Observable<String>
        var items: Driver<[SearchTableViewSection]>
        
        var isLoadingSpinnerAvaliable: Observable<Bool>
        var refreshControlCompelted: Observable<Void>
    }
    
    struct Dependencies {
        var dateFromObservable: Observable<Date?>
        var dateToObservable: Observable<Date?>
    }
    
    private let disposeBag = DisposeBag()
    private let newsService = NewsService()
    private let tableHeaderValue = BehaviorSubject<String>(value: "Search History")
    private let items = PublishSubject<[SearchTableViewSection]>()
    private let historyRecords = PublishSubject<[String]>()
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(_ input: Input) -> Output {
        let input: NewsService.Input = .init(inputString: input.inputString,
                                             featchMore: input.featchMore,
                                             refreshControlEvent: input.refreshControlEvent,
                                             dateFrom: dependencies.dateFromObservable.startWith(nil).debounce(.seconds(3),
                                                                                                               scheduler: MainScheduler.instance),
                                             dateTo: dependencies.dateToObservable.startWith(nil).debounce(.seconds(3),
                                                                                                           scheduler: MainScheduler.instance))
        let newsServiceOuput = newsService.transform(input)
        
        input.inputString
            .subscribe(onNext: { string in
                let isExists = SearchHistoryManager().isExists(searchedText: string)
                if (!isExists) {
                    SearchHistoryManager().addSearchRecord(nameValue: string)
                }
            }).disposed(by: disposeBag)
        
        let historyRecordsDriver: Driver<[SearchTableViewSection]> = historyRecords
            .asDriver(onErrorDriveWith: .never())
            .map { searchHistoryRecords -> [SearchTableViewSection] in
                var searchHistoryItems: [SearchTableViewItem] = []
                
                for (index, record) in searchHistoryRecords.enumerated() {
                    if index == 0 {
                        searchHistoryItems = [.searchHistory(title: record)]
                    } else {
                        searchHistoryItems.append(.searchHistory(title: record))
                    }
                }
                return [.searchHistory(items: searchHistoryItems)]
            }
        
        historyRecordsDriver
            .drive(items)
            .disposed(by: disposeBag)
        
        newsServiceOuput.totalArticals.map { totalArticles -> String in
            return "\(totalArticles) News"
        }.asDriver(onErrorDriveWith: .never())
            .drive(tableHeaderValue)
            .disposed(by: disposeBag)
        
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
        
        return .init(tableHeaderValue: tableHeaderValue.asObserver(),
                     items: items.asDriver(onErrorDriveWith: .never()),
                     isLoadingSpinnerAvaliable: newsServiceOuput.isLoadingSpinnerAvaliable,
                     refreshControlCompelted: newsServiceOuput.refreshControlCompelted)
    }
    
    func loadHistoryItems() {
        historyRecords.onNext(SearchHistoryManager().getHistoryRecords())
    }
}
