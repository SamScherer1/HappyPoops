//
//  FoodTypeCircle.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 3/30/21.
//  Copyright © 2021 SamuelScherer. All rights reserved.
//

import Foundation

class FoodTypeCircle: UIView {
    var isActive = false
    var characterLabel = UILabel()
    fileprivate var circleColor = UIColor.green
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    convenience init(initialCharacter : String, color : UIColor) {
        self.init(frame: CGRect.zero)
        self.characterLabel.text = initialCharacter
        //self.backgroundColor = color
        setupView()
    }


    func setupView() {
        self.layer.cornerRadius = 5.0
        self.widthAnchor.constraint(equalTo:self.heightAnchor).isActive = true
        self.characterLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.characterLabel)
        self.characterLabel.textColor = UIColor.black
        self.characterLabel.font = UIFont.systemFont(ofSize: 20)
        self.characterLabel.textAlignment = NSTextAlignment.center
        self.characterLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.characterLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.characterLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
