//
//  DateCell.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 6/29/21.
//

import Foundation
import UIKit

class DateCell: UITableViewCell {
    
    var dateLabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    func setupView() {
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.dateLabel)
        self.dateLabel.textColor = .gray
        self.dateLabel.text = "-DATE-"
        self.dateLabel.font = UIFont.systemFont(ofSize: 8.0)
        
        self.dateLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.dateLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
    }
}
