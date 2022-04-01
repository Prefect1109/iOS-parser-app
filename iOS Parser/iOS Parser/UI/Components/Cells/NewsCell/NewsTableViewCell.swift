//
//  NewsTableViewCell.swift
//  iOS Parser
//
//  Created by Prefect on 28.03.2022.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var backgroundStackView: UIStackView!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = R.color.backgroundGrey()
        backgroundStackView.backgroundColor = .white
        backgroundStackView.addShadow(offset: .init(width: 0, height: 6),
                                      color: R.color.shadowColor()!,
                                      radius: 20,
                                      opacity: 0.06)
    }
}
