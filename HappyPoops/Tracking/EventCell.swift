//
//  TrackCell.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 6/24/21.
//

import Foundation
import UIKit

class EventCell: UITableViewCell {
    
    var timeLabel = UILabel()
    var insetBackgroundView = UIView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    func setupView() {
        self.insetBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.insetBackgroundView)

        self.insetBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
        self.insetBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0).isActive = true
        
        self.insetBackgroundView.layer.cornerRadius = 15.0
        self.insetBackgroundView.backgroundColor = .halfTransparentDarkColor()
        self.backgroundColor = .clear
        
        self.timeLabel.textColor = .gray
        self.timeLabel.isHidden = true
        self.timeLabel.textAlignment = .center
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.timeLabel)
        self.timeLabel.centerYAnchor.constraint(equalTo: super.contentView.centerYAnchor).isActive = true


        
    }
}
