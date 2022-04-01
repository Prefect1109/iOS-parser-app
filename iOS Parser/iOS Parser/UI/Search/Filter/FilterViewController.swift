//
//  FilterViewController.swift
//  iOS Parser
//
//  Created by Prefect on 01.04.2022.
//

import Foundation

import UIKit

class FilterViewController: UIViewController {
    
    var viewModel: FilterViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func configure(viewModel: FilterViewModel) {
        self.viewModel = viewModel
    }
    
    private func configureUI() {
        let topTitleLabel = UILabel()
        topTitleLabel.text = "Logo"
        topTitleLabel.font = R.font.openSansBoldItalic(size: 30)
        topTitleLabel.textColor = R.color.accentColor()
        
        navigationController?.navigationBar.topItem?.titleView = topTitleLabel
    }
}
