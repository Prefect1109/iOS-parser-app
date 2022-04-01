//
//  MoreCoordinator.swift
//  iOS Parser
//
//  Created by Prefect on 27.03.2022.
//

import UIKit
import Moya

class MoreCoordinator: Coordinator {
    
    var navigationController = UINavigationController()
        
    func start() {
        guard let viewController = R.storyboard.more.instantiateInitialViewController() else { return }
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = "More"
        navigationController.tabBarItem.image = UIImage(systemName: "ellipsis.circle.fill")!
//        let viewModel = HomeViewModel()
//        viewController.configure(with: viewModel)
    }
}
