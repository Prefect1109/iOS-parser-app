//
//  FilterViewController.swift
//  iOS Parser
//
//  Created by Prefect on 01.04.2022.
//

import Foundation
import UIKit
import RxSwift

class FilterViewController: UIViewController {
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var fromDateTextFieldView: DateTextFieldView!
    @IBOutlet weak var toDateTextFieldView: DateTextFieldView!
    
    private let disposeBag = DisposeBag()
    var viewModel: FilterViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    
    func configure(viewModel: FilterViewModel) {
        self.viewModel = viewModel
    }
    
    private func configureUI() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        fromDateTextFieldView.titleLabel.text = "From"
        
        toDateTextFieldView.titleLabel.text = "To"
    }
    
    func bind() {
        guard let viewModel = viewModel else { return }
        let _ = viewModel.transform(.init(fromDate: fromDateTextFieldView.textField.rx.text.orEmpty.asObservable(),
                                          toDate: toDateTextFieldView.textField.rx.text.orEmpty.asObservable()))
        
        backButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        clearButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.fromDateTextFieldView.textField.text = ""
            self.toDateTextFieldView.textField.text = ""
        }).disposed(by: disposeBag)
    }
}
