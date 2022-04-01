//
//  TabBar.swift
//  iOS Parser
//
//  Created by Prefect on 24.03.2022.
//

import UIKit
import Moya

class TabBar: UITabBarController {
    
    private var customTabBarView = UIView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBarUI()
        self.addCustomTabBarView()
        setupVCs()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupCustomTabBarFrame()
    }
    
    private func setupTabBarUI() {
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = R.color.sacoBlue()
        self.tabBar.unselectedItemTintColor = R.color.grey2()
    }
    
    private func setupCustomTabBarFrame() {
        let height = self.view.safeAreaInsets.bottom + 64
        
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = height
        tabFrame.origin.y = self.view.frame.size.height - height
        
        self.tabBar.frame = tabFrame
        self.tabBar.setNeedsLayout()
        self.tabBar.layoutIfNeeded()
        customTabBarView.frame = tabBar.frame
    }
    
    private func addCustomTabBarView() {
        self.customTabBarView.frame = tabBar.frame
        self.customTabBarView.backgroundColor = R.color.sacoBlue()
        self.customTabBarView.layer.masksToBounds = false
        self.customTabBarView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.customTabBarView.layer.shadowOffset = CGSize(width: -4, height: -6)
        self.customTabBarView.layer.shadowOpacity = 0.3
        self.customTabBarView.layer.shadowRadius = 20
        
        self.view.addSubview(customTabBarView)
        self.view.bringSubviewToFront(self.tabBar)
    }
    
    func setupVCs() {
        viewControllers = [
            getNavController(for: HomeCoordinator()),
            getNavController(for: NewsCoordinator()),
            getNavController(for: SearchCoordinator()),
            getNavController(for: ProfileCoordinator()),
            getNavController(for: MoreCoordinator())
        ]
    }
    
    fileprivate func getNavController(for coordinator: Coordinator) -> UIViewController {
        coordinator.start()
        return coordinator.navigationController
    }
}
