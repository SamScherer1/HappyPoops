//
//  InsightTableViewCell.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 6/23/21.
//  Copyright © 2021 SamuelScherer. All rights reserved.
//

import Foundation

class InsightTableViewCell: UITableViewCell {
    
    var arrowView : UIImageView!
    var titleLabel : UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    func setupView() {
        self.arrowView = UIImageView.init(image: UIImage.init(systemName: "chevron.right"))
        self.arrowView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.arrowView)
        self.arrowView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5.0).isActive = true
        self.arrowView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5.0).isActive = true
        self.arrowView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5.0).isActive = true
        self.arrowView.widthAnchor.constraint(equalTo: self.arrowView.heightAnchor).isActive = true
        
        self.titleLabel = UILabel.init()
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.leftAnchor.constraint(equalTo: self.arrowView.rightAnchor, constant: 15.0).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.arrowView.topAnchor).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.arrowView.bottomAnchor).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5.0).isActive = true
        self.titleLabel.text = "Food Type Title"
        self.titleLabel.textColor = .white
        
        //TODO: add KVO for title, chevron color to update the view...
        
    }
    
}
