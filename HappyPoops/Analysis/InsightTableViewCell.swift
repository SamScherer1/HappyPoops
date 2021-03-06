//
//  InsightTableViewCell.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 6/23/21.
//  Copyright © 2021 SamuelScherer. All rights reserved.
//

import Foundation
import UIKit

class InsightTableViewCell: UITableViewCell {
    
    var arrowView = UIImageView.init(image: UIImage.init(systemName: "chevron.right.circle"))
    var titleLabel = UILabel()
    var insightsLabel = UILabel()
    
    var cellHeightConstraint : NSLayoutConstraint?
    var insightsHeightConstraint : NSLayoutConstraint?
    
    var arrowInitialized = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    func setupView() {
        self.cellHeightConstraint = self.contentView.heightAnchor.constraint(equalToConstant: 30.0)
        self.cellHeightConstraint?.isActive = true
        
        self.arrowView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.arrowView)
        self.arrowView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5.0).isActive = true
        self.arrowView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5.0).isActive = true
        self.arrowView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5.0).isActive = true
        self.arrowView.widthAnchor.constraint(equalTo: self.arrowView.heightAnchor).isActive = true
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15.0).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.arrowView.topAnchor).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.arrowView.bottomAnchor).isActive = true
        self.titleLabel.text = "Food Type Title"
        self.titleLabel.textColor = .white
        self.selectionStyle = .none

        self.insightsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.insightsLabel)
        self.insightsLabel.textColor = .white
        self.insightsLabel.text = "TEST TEXT"
        self.insightsLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor, constant: 5.0).isActive = true
        self.insightsLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5.0).isActive = true
        self.insightsHeightConstraint = self.insightsLabel.heightAnchor.constraint(equalToConstant: 0)
        self.insightsHeightConstraint?.isActive = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if !arrowInitialized {
            arrowInitialized = true
            return
        }
        
        if selected && !self.isSelected {
            showDetails()
        } else if !selected && self.isSelected {
            hideDetails()
        }
        super.setSelected(selected, animated: animated)
    }
    
    func showDetails() {
        //Rotate arrow
        UIView.animate(withDuration: 0.5, animations: {
            self.arrowView.transform = self.arrowView.transform.rotated(by: .pi/2.0)
        })

        //Increase cell size/ show content
        self.cellHeightConstraint?.constant = 100.0
        self.insightsHeightConstraint?.constant = 70.0
    }
    
    func hideDetails() {
        //Rotate arrow
        UIView.animate(withDuration: 0.5) {
            self.arrowView.transform = self.arrowView.transform.rotated(by: -1 * .pi/2.0)
        }

        //Decrease cell size/ show content
        self.cellHeightConstraint?.constant = 30.0
        self.insightsHeightConstraint?.constant = 0.0
    }
}
