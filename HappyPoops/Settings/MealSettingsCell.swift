//
//  MealSettingsCell.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 6/24/21.
//

import Foundation

class MealSettingsCell: UITableViewCell {
    var foodType: FoodType?
    var foodTypeCircle = FoodTypeCircle()
    var titleLabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    func setupView() {
        self.backgroundColor = .clear
        
        self.foodTypeCircle.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.foodTypeCircle)
        self.foodTypeCircle.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.foodTypeCircle.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.85).isActive = true
        self.foodTypeCircle.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -15.0).isActive = true
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15.0).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5.0).isActive = true
        self.titleLabel.textColor = .white
        
        self.addObserver(self, forKeyPath: "foodType", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == "foodType" {

        }
    }
    
    func update() {
        self.titleLabel.text = self.foodType?.name ?? "Food Type"
        self.foodTypeCircle.characterLabel.text = String((self.foodType?.name ?? "F").prefix(1))
        if let foodTypeColorData = self.foodType?.color {
            do {
                self.foodTypeCircle.backgroundColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self,
                                                                                   from: foodTypeColorData)
            } catch {
                NSLog("Failed to unarchive food type color: \(self.foodType?.description ?? "nil")")
            }
        }
    }
    
    func update(with foodType:FoodType) {
        self.foodType = foodType
        self.update()
    }
}
