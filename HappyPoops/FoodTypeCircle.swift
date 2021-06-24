//
//  FoodTypeCircle.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 3/30/21.
//  Copyright © 2021 SamuelScherer. All rights reserved.
//

import Foundation

class FoodTypeCircle: UIView {
    public var letterTitle : String?
    public var color : UIColor?
    var isActive = false
    var characterLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    convenience init(initialCharacter : String, color : UIColor) {
        self.init(frame: CGRect.zero)
        self.letterTitle = initialCharacter
        self.color = color
        setupView()
    }

    func setupView() {
        self.backgroundColor = UIColor.green
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
        if let character = letterTitle {
            self.characterLabel.text = character
        }
        
        self.addObserver(self, forKeyPath: "letterTitle", options: NSKeyValueObservingOptions.new, context: nil)
        self.addObserver(self, forKeyPath: "color", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPathNonNil = keyPath else {
            return
        }
        if (keyPathNonNil.elementsEqual("letterTitle")) {
            self.characterLabel.text = self.letterTitle
        } else if (keyPathNonNil.elementsEqual("color")) {
            self.backgroundColor = self.color
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}
