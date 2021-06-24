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
        //super.insetBackgroundView.rightAnchor.constraint(equalTo: super.rightAnchor, constant: -150.0).isActive = true
        
        self.updateCircles()
        
        self.circlesStackView.leftAnchor.constraint(equalTo: super.insetBackgroundView.leftAnchor, constant: 15.0).isActive = true
        self.circlesStackView.topAnchor.constraint(equalTo: super.insetBackgroundView.topAnchor, constant: 5.0).isActive = true
        self.circlesStackView.rightAnchor.constraint(equalTo: super.insetBackgroundView.rightAnchor, constant: -15.0).isActive = true
        self.circlesStackView.bottomAnchor.constraint(equalTo: super.insetBackgroundView.bottomAnchor, constant: -5.0).isActive = true

        self.addObserver(self, forKeyPath: "mealDictionary", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "mealDictionary" {
            self.updateCircles()
        }
    }
    
    func updateCircles() {
//        NSArray *circleViews = [self.circlesStackView arrangedSubviews];
//        for (UIView *view in circleViews) {
//            [self.circlesStackView removeArrangedSubview:view];
//        }
        let circleViews = self.circlesStackView.arrangedSubviews
        for view in circleViews {
            self.circlesStackView.removeArrangedSubview(view)
        }
//
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        NSArray *foodTypes = [appDelegate fetchFoodTypes];
        guard let foodTypes = appDelegate.fetchFoodTypes() else { return }
//        for (FoodType *foodType in foodTypes) {
//            FoodTypeCircle *circle = [FoodTypeCircle new];
//    //        circle.letterTitle = [foodType.name substringToIndex:1];
//    //        NSNumber *hasEatenFoodTypeNumber = [self.mealDictionary valueForKey:foodType.name];
//    //        if (hasEatenFoodTypeNumber.boolValue) {
//    //            circle.color = [NSKeyedUnarchiver unarchivedObjectOfClass:UIColor.class fromData:foodType.color error:nil];
//    //        } else {
//    //            circle.color = UIColor.grayColor;
//    //        }
//            [self.circlesStackView addArrangedSubview:circle];
//        }
        for foodType in foodTypes {
            let circleLetter = String((foodType.name?.prefix(1))!)//TODO: reconsider force unwrap
            var circleColor = UIColor.gray
            if let mealDictionary = self.mealDictionary {
                if let hasEatenFood = mealDictionary[foodType.name!], hasEatenFood {//TODO: reconsider force unwrap
                    //    circle.color = [NSKeyedUnarchiver unarchivedObjectOfClass:UIColor.class fromData:foodType.color error:nil];
                    circleColor = .red //TODO: actually unwrap color...
                }
            }
            
            let circle = FoodTypeCircle(initialCharacter: circleLetter, color: circleColor)
            self.circlesStackView.addArrangedSubview(circle)
        }

        
    }
    
}
