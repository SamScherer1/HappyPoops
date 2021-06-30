//
//  TrackCell.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 6/24/21.
//

import Foundation
import UIKit

class EventCell: UITableViewCell {
    
    var dateLabel = UILabel()
    var timeLabel = UILabel()
    var insetBackgroundView = UIView()
    var dateLabelHeightConstraint : NSLayoutConstraint?
    
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
        self.addSubview(self.dateLabel)
        self.dateLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.dateLabel.textColor = .gray
        self.dateLabelHeightConstraint = self.dateLabel.heightAnchor.constraint(equalToConstant: 5.0)
        self.dateLabelHeightConstraint?.isActive = true
        
        self.dateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.dateLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        
        self.insetBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.insetBackgroundView)

        self.insetBackgroundView.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 2.0).isActive = true
        self.insetBackgroundView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5.0).isActive = true
        self.insetBackgroundView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        self.insetBackgroundView.layer.cornerRadius = 15.0
        self.insetBackgroundView.backgroundColor = .halfTransparentDarkColor()
        self.backgroundColor = .clear
        
        self.timeLabel.textColor = .gray
        self.timeLabel.isHidden = true
        self.timeLabel.textAlignment = .center
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.timeLabel)
        self.timeLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }
    
    override func updateConstraints() {
        <#code#>
    }
}
