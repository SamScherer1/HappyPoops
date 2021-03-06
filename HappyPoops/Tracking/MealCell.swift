//
//  MealCell.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 6/24/21.
//

import Foundation
import UIKit

class MealCell: EventCell {
    
    var container: PersistentContainer?
    
    var circlesStackView = UIStackView.init(arrangedSubviews: [])
    
    var mealDictionary : [String:Bool]?
    
    var stackViewWidthConstraint : NSLayoutConstraint?
    
    fileprivate let circleSpacing = CGFloat(5.0)
    
    override func setupView() {
        super.setupView()
        super.insetBackgroundView.leftAnchor.constraint(equalTo: super.contentView.leftAnchor, constant: 15.0).isActive = true
        self.circlesStackView.distribution = .equalSpacing
        self.circlesStackView.spacing = circleSpacing
        self.circlesStackView.translatesAutoresizingMaskIntoConstraints = false
        super.insetBackgroundView.addSubview(self.circlesStackView)
        
        self.updateCircles()
        
        self.circlesStackView.leftAnchor.constraint(equalTo: super.insetBackgroundView.leftAnchor, constant: 15.0).isActive = true
        self.circlesStackView.topAnchor.constraint(equalTo: super.insetBackgroundView.topAnchor, constant: 5.0).isActive = true
        self.circlesStackView.rightAnchor.constraint(equalTo: super.insetBackgroundView.rightAnchor, constant: -15.0).isActive = true
        self.circlesStackView.bottomAnchor.constraint(equalTo: super.insetBackgroundView.bottomAnchor, constant: -5.0).isActive = true
        
        
        self.timeLabel.leftAnchor.constraint(equalTo: super.insetBackgroundView.rightAnchor).isActive = true
        self.timeLabel.rightAnchor.constraint(equalTo: super.contentView.rightAnchor).isActive = true
    }
    
    func updateCircles(with mealDictionary:[String: Bool]) {
        self.mealDictionary = mealDictionary
        self.updateCircles()
        self.stackViewWidthConstraint?.isActive = false
        let circles = self.circlesStackView.arrangedSubviews
        let stackViewWidth = (50 * circles.count) + ((circles.count - 1) * Int(circleSpacing))
        self.stackViewWidthConstraint = self.circlesStackView.widthAnchor.constraint(equalToConstant: CGFloat(stackViewWidth))
        self.stackViewWidthConstraint?.isActive = true
    }
    
    func updateCircles() {
        let circleViews = self.circlesStackView.arrangedSubviews
        for view in circleViews {
            self.circlesStackView.removeArrangedSubview(view)
        }
        
        if let foodTypes = self.container?.fetchFoodTypes() {
            for foodType in foodTypes {
                let circleLetter = String((foodType.name?.prefix(1))!)//TODO: reconsider force unwrap
                var circleColor = UIColor.gray
                if let mealDictionary = self.mealDictionary {
                    if let hasEatenFood = mealDictionary[foodType.name!], hasEatenFood {//TODO: reconsider force unwrap
                        if let foodTypeColor = foodType.color {
                            do {
                                if let unwrappedColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: foodTypeColor) {
                                    circleColor = unwrappedColor
                                }
                            } catch {
                                fatalError()
                            }
                        }
                    }
                }

                let circle = FoodTypeCircle(initialCharacter: circleLetter, color: circleColor)
                circle.backgroundColor = circleColor
                self.circlesStackView.addArrangedSubview(circle)
            }
        }
    }
}
