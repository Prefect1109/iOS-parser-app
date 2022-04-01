//
//  SearchTextField.swift
//  iOS Parser
//
//  Created by Prefect on 31.03.2022.
//

import UIKit

class SearchTextField: UITextField {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private var leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.dandruff()
        return imageView
    }()
    
    var leftPaddingValue: CGFloat = 5
    var padding: UIEdgeInsets {
        get {
            UIEdgeInsets(top: 0, left: leftPaddingValue, bottom: 0, right: 5)
        }
    }
    
    private func commonInit() {
        borderStyle = .none
        layer.cornerRadius = 23
        layer.backgroundColor = R.color.backgroundGrey()?.cgColor
        placeholder = "Search"
        
        font = R.font.openSansSemiBold(size: 14)
        
        addSubview(leftImageView)
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 13),
            leftImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        leftPaddingValue = 22 + leftImageView.frame.width
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
