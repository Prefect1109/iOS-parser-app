//
//  ViewModelType.swift
//  iOS Parser
//
//  Created by Prefect on 07.04.2022.
//

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    associatedtype Dependencies
    
    func transform(_ input: Input) -> Output
}
