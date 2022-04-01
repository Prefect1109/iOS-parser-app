//
//  CircleButton.swift
//  iOS Parser
//
//  Created by Prefect on 31.03.2022.
//

import Foundation
import UIKit

class CircleButton: UIButton {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    @IBInspectable var image: UIImage? {
        set { iconImageView.image = newValue }
        get { return iconImageView.image}
    }
    
    private var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    func commonInit() {
        layer.cornerRadius = 23
        backgroundColor = R.color.backgroundGrey()
        
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
