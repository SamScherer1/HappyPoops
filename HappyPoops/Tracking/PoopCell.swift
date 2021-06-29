//
//  PoopCell.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 6/24/21.
//

import Foundation
import UIKit

class PoopCell: TrackCell {
    var ratingLabel = UILabel()
    var ratingBarBackground = UIView()
    var ratingBar = UIView()
    var barWidthConstraint : NSLayoutConstraint?
    
    func set(quality:Int) {
        self.ratingLabel.text = String(quality)
        self.barWidthConstraint?.isActive = false
        // Show a tiny bit of bar for 0 so you can see the red
        let barWidthMultiplier = quality == 0 ? 0.05 : (Double(quality) / 10.0)

        self.barWidthConstraint = self.ratingBar.widthAnchor.constraint(equalTo: self.ratingBarBackground.widthAnchor,
                                                                        multiplier: CGFloat(barWidthMultiplier))
        self.barWidthConstraint?.isActive = true
        if quality < 4 {
            self.ratingBar.backgroundColor = .red
        } else if quality >= 4 && quality < 7 {
            self.ratingBar.backgroundColor = .orange
        } else {
            self.ratingBar.backgroundColor = .green
        }

        if quality == 10 {
            self.ratingBar.layer.maskedCorners = [.layerMinXMinYCorner,
                                                  .layerMinXMaxYCorner,
                                                  .layerMaxXMinYCorner,
                                                  .layerMaxXMaxYCorner]
        } else {
            self.ratingBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }
    }
    
    override func setupView() {
        super.setupView()
        
        super.insetBackgroundView.leftAnchor.constraint(equalTo: super.leftAnchor, constant: 150.0).isActive = true
        super.insetBackgroundView.rightAnchor.constraint(equalTo: super.rightAnchor, constant: -15.0).isActive = true
        
        self.ratingBarBackground.translatesAutoresizingMaskIntoConstraints = false
        self.ratingBarBackground.backgroundColor = .gray
        self.ratingBarBackground.layer.cornerRadius = 10.0
        
        super.insetBackgroundView.addSubview(self.ratingBarBackground)
        self.ratingBarBackground.leftAnchor.constraint(equalTo: super.insetBackgroundView.leftAnchor, constant: 5.0).isActive = true
        self.ratingBarBackground.rightAnchor.constraint(equalTo: super.insetBackgroundView.rightAnchor, constant: -5.0).isActive = true
        self.ratingBarBackground.topAnchor.constraint(equalTo: super.insetBackgroundView.topAnchor, constant: 5.0).isActive = true
        self.ratingBarBackground.bottomAnchor.constraint(equalTo: super.insetBackgroundView.bottomAnchor, constant: -5.0).isActive = true
        
        super.insetBackgroundView.addSubview(self.ratingBar)

        self.ratingBar.translatesAutoresizingMaskIntoConstraints = false
        self.ratingBar.backgroundColor = .green

        super.insetBackgroundView.addSubview(self.ratingBar)
        self.ratingBar.leftAnchor.constraint(equalTo: self.ratingBarBackground.leftAnchor).isActive = true
        self.ratingBar.topAnchor.constraint(equalTo: self.ratingBarBackground.topAnchor).isActive = true
        self.ratingBar.bottomAnchor.constraint(equalTo: self.ratingBarBackground.bottomAnchor).isActive = true

        self.barWidthConstraint = self.ratingBar.widthAnchor.constraint(equalTo: self.ratingBarBackground.widthAnchor, multiplier: 0.7)
        self.barWidthConstraint?.isActive = true
        self.ratingBar.layer.cornerRadius = 10.0
        self.ratingBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]

        self.ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.ratingLabel.textColor = .black
        self.ratingLabel.font = UIFont.systemFont(ofSize: 20.0)
        super.insetBackgroundView.addSubview(self.ratingLabel)
        self.ratingLabel.centerXAnchor.constraint(equalTo: self.ratingBarBackground.centerXAnchor).isActive = true
        self.ratingLabel.centerYAnchor.constraint(equalTo: self.ratingBarBackground.centerYAnchor).isActive = true
    }
}
