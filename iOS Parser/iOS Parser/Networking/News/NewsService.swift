//
//  NewsService.swift
//  iOS Parser
//
//  Created by Prefect on 31.03.2022.
//

import Darwin
import RxSwift
import RxCocoa

class NewsService {
    
    private var disposeBag = DisposeBag()
    private var pageCounter = 1
    private var maxValueOfPageCounter = 1
    private var pagesPerLoad = 10
    private var isPaginationRequestStillResume = false
    private var isRefreshRequstStillResume = false
    private var lastString = ""
    
    private let items = BehaviorRelay<[Article]>(value: [])
    private let totalArticlesSubject = PublishSubject<Int>()
    private let inputStringRelay = PublishRelay<String>()
    private let isLoadingSpinnerAvaliable = PublishSubject<Bool>()
    private let refreshControlCompelted = PublishSubject<Void>()
    
    struct Input {
        var inputString: Observable<String>
        var featchMore: Observable<Void>
        var refreshControlEvent: Observable<Void>
    }
    
    struct Output {
        var articles: Observable<[Article]>
        var totalArticals: Observable<Int>
        var isLoadingSpinnerAvaliable: Observable<Bool>
        var refreshControlCompelted: Observable<Void>
    }
    
    func transform(_ input: Input) -> Output {
        
        input.inputString
            .bind(to: inputStringRelay)
            .disposed(by: disposeBag)
        
        let requestInput = Observable.combineLatest(input.featchMore.startWith(()),
                                                    inputStringRelay.asObservable())
        requestInput.subscribe { [weak self] _, inputString in
            guard let self = self else { return }
            self.fetchData(page: self.pageCounter,
                           isRefreshControl: false,
                           inputString: inputString)
        }.disposed(by: disposeBag)
        
        input.refreshControlEvent.subscribe { [weak self] _ in
            self?.refreshControlTriggered()
        }.disposed(by: disposeBag)
        
        return .init(articles: items.asObservable(),
                     totalArticals: totalArticlesSubject.asObservable(),
                     isLoadingSpinnerAvaliable: isLoadingSpinnerAvaliable.asObservable(),
                     refreshControlCompelted: refreshControlCompelted.asObservable())
    }
    
    private func fetchData(page: Int, isRefreshControl: Bool, inputString: String) {
        if isPaginationRequestStillResume || isRefreshRequstStillResume { return }
        self.isRefreshRequstStillResume = isRefreshControl
        
        if pageCounter > maxValueOfPageCounter  {
            isPaginationRequestStillResume = false
            return
        }
        
        isPaginationRequestStillResume = true
        isLoadingSpinnerAvaliable.onNext(true)
        
        if pageCounter == 1 || isRefreshControl {
            isLoadingSpinnerAvaliable.onNext(false)
        }
        
        lastString = inputString // for refresh event
        let target = NewsTarget(input: inputString,
                                page: pageCounter,
                                max: pagesPerLoad)
        
        let responseSingle: Single<NewsResponse> = NetworkingService.shared.createSingle(target: target)
        
        responseSingle.subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            self.handleData(response)
            self.isLoadingSpinnerAvaliable.onNext(false)
            self.isPaginationRequestStillResume = false
            self.isRefreshRequstStillResume = false
            self.refreshControlCompelted.onNext(())
        }, onFailure: { [weak self] error in
            guard let self = self else { return }
            NetworkingService.shared.cancelRequests()
            self.isLoadingSpinnerAvaliable.onNext(false)
            self.isPaginationRequestStillResume = false
            self.pageCounter = 1
        }).disposed(by: disposeBag)
    }
    
    private func handleData(_ response: NewsResponse) {
        let totalArticles = Double(response.totalArticles)
        totalArticlesSubject.onNext(response.totalArticles)
        var maxValueOfPageCounterDouble = totalArticles / Double(pageCounter)
        maxValueOfPageCounterDouble.round(.up)
        maxValueOfPageCounter = Int(maxValueOfPageCounterDouble)
        if pageCounter == 1 {
            items.accept(response.articles)
        } else {
            let oldData = items.value
            items.accept(oldData + response.articles)
        }
        pageCounter += 1
    }
    
    private func refreshControlTriggered() {
        NetworkingService.shared.cancelRequests()
        isPaginationRequestStillResume = false
        pageCounter = 1
        items.accept([])
        fetchData(page: pageCounter,
                  isRefreshControl: true,
                  inputString: lastString)
    }
}
