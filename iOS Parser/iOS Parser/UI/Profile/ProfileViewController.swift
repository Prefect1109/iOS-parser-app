//
//  ProfileViewController.swift
//  iOS Parser
//
//  Created by Prefect on 27.03.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var viewModel: ProfileViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.color.backgroundGrey()
    }
    
    func configure(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
}
