//
//  UIView+addShadow.swift
//  iOS Parser
//
//  Created by Prefect on 28.03.2022.
//

import UIKit

extension UIView {
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        backgroundColor = nil
        layer.backgroundColor =  backgroundColor?.cgColor
    }
}
