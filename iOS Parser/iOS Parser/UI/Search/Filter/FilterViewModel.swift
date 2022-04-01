//
//  FilterViewModel.swift
//  iOS Parser
//
//  Created by Prefect on 01.04.2022.
//

import RxSwift
import RxCocoa

class FilterViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let dateFromSubject: PublishSubject<Date?>
    private let dateToSubject: PublishSubject<Date?>
    
    init(dateFromSubject: PublishSubject<Date?>, dateToSubject: PublishSubject<Date?>) {
        self.dateFromSubject = dateFromSubject
        self.dateToSubject = dateToSubject
    }
    
    struct Input {
        var fromDate: Observable<String>
        var toDate: Observable<String>
    }
    
    struct Output { }
    
    func transform(_ input: Input) -> Output {
        input.fromDate.map { string -> Date? in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            let date = formatter.date(from: string)
            let newFormatter = ISO8601DateFormatter()
            guard let safeDate = date else { return nil }
            let newDateString = newFormatter.date(from: safeDate.ISO8601Format())
            return newDateString
        }.asDriver(onErrorDriveWith: .never())
        .drive(dateFromSubject)
        .disposed(by: disposeBag)
        
        input.toDate.map { string -> Date? in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            let date = formatter.date(from: string)
            let newFormatter = ISO8601DateFormatter()
            guard let safeDate = date else { return nil }
            let newDateString = newFormatter.date(from: safeDate.ISO8601Format())
            return newDateString
        }.asDriver(onErrorDriveWith: .never())
        .drive(dateToSubject)
        .disposed(by: disposeBag)
        
        return .init()
    }
}
