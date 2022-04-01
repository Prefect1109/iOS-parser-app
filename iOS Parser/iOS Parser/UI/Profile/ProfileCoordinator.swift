//
//  ProfileCoordinator.swift
//  iOS Parser
//
//  Created by Prefect on 27.03.2022.
//

import UIKit
import Moya

class ProfileCoordinator: Coordinator {
    
    var navigationController = UINavigationController()
        
    func start() {
        guard let viewController = R.storyboard.profile.instantiateInitialViewController() else { return }
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = "Profile"
        navigationController.tabBarItem.image = UIImage(systemName: "person")!
//        let viewModel = HomeViewModel()
//        viewController.configure(with: viewModel)
    }
}
