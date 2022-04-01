//
//  HomeCoordinator.swift
//  iOS Parser
//
//  Created by Prefect on 27.03.2022.
//

import UIKit
import Moya

class HomeCoordinator: Coordinator {
    
    var navigationController = UINavigationController()
        
    func start() {
        guard let viewController = R.storyboard.home.instantiateInitialViewController() else { return }
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = "Home"
        navigationController.tabBarItem.image = UIImage(systemName: "house")!
//        let viewModel = HomeViewModel()
//        viewController.configure(with: viewModel)
    }
}
