//
//  MoreViewModel.swift
//  iOS Parser
//
//  Created by Prefect on 27.03.2022.
//

class MoreViewModel: ViewModelType {
    struct Input {}
    struct Output {}
    struct Dependencies {}
    
    private var dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(_ input: Input) -> Output {
        return .init()
    }
}
