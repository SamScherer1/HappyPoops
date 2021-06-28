//
//  MealCell.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 6/24/21.
//

import Foundation

class MealCell: TrackCell {
    
    var circlesStackView = UIStackView.init(arrangedSubviews: [])
    
    var mealDictionary : [String:Bool]?

    override func setupView() {
        super.setupView()
        super.insetBackgroundView.leftAnchor.constraint(equalTo: super.leftAnchor, constant: 15.0).isActive = true
        self.circlesStackView.distribution = .equalSpacing
        self.circlesStackView.spacing = 10.0
        self.circlesStackView.translatesAutoresizingMaskIntoConstraints = false
        super.insetBackgroundView.addSubview(self.circlesStackView)
        
        self.updateCircles()
        
        self.circlesStackView.leftAnchor.constraint(equalTo: super.insetBackgroundView.leftAnchor, constant: 15.0).isActive = true
        self.circlesStackView.topAnchor.constraint(equalTo: super.insetBackgroundView.topAnchor, constant: 5.0).isActive = true
        self.circlesStackView.rightAnchor.constraint(equalTo: super.insetBackgroundView.rightAnchor, constant: -15.0).isActive = true
        self.circlesStackView.bottomAnchor.constraint(equalTo: super.insetBackgroundView.bottomAnchor, constant: -5.0).isActive = true
    }
    
    func updateCircles(with mealDictionary:[String: Bool]) {
        self.mealDictionary = mealDictionary
        self.updateCircles()
    }
    
    func updateCircles() {
        let circleViews = self.circlesStackView.arrangedSubviews
        for view in circleViews {
            self.circlesStackView.removeArrangedSubview(view)
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let foodTypes = appDelegate.fetchFoodTypes() else { return }
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
