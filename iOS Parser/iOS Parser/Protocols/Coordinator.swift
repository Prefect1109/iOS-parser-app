//
//  Coordinator.swift
//  iOS Parser
//
//  Created by Prefect on 27.03.2022.
//

import UIKit
import Moya

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
