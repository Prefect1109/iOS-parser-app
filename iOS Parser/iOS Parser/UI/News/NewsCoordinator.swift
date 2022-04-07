//
//  NewsCoordinator.swift
//  iOS Parser
//
//  Created by Prefect on 23.03.2022.
//

import UIKit
import Moya

class NewsCoordinator: Coordinator {
    
    var navigationController = UINavigationController()
    
    func start() {
        guard let viewController = R.storyboard.news.instantiateInitialViewController() else { return }
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = "News"
        navigationController.tabBarItem.image = UIImage(systemName: "circle.grid.2x2")!
        let viewModel = NewsViewModel(dependencies: .init())
        viewController.configure(viewModel: viewModel,
                                 showArticle: showArticle)
    }
    
    func showArticle(with url: URL) {
        guard let viewController = R.storyboard.article.instantiateInitialViewController() else { return }
        navigationController.present(viewController, animated: true)
        viewController.showArticle(with: url)
    }
}
