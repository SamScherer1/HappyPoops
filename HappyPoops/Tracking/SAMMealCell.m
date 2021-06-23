//
//  SAMMealCell.m
//  HappyPoops
//
//  Created by Samuel Scherer on 3/17/21.
//  Copyright © 2021 SamuelScherer. All rights reserved.
//

#import "SAMMealCell.h"
#import "HappyPoops-Swift.h"
//#import "FoodType+CoreDataClass.h"

@interface SAMMealCell()

@property (strong, nonatomic) UIStackView *circlesStackView;
@property (strong, nonatomic) NSArray *circlesArray;


@end

@implementation SAMMealCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupView {
    [super setupView];
    [super.insetBackgroundView.leftAnchor constraintEqualToAnchor:super.leftAnchor constant:15].active = YES;
    self.circlesStackView = [[UIStackView alloc] initWithArrangedSubviews:@[]];
    self.circlesStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.circlesStackView.spacing = 10.0;
    self.circlesStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [super.insetBackgroundView addSubview:self.circlesStackView];
    //[super.insetBackgroundView.rightAnchor constraintEqualToAnchor:super.rightAnchor constant:-150].active = YES;
    
    [self updateCircles];
    
    [self addObserver:self forKeyPath:@"mealDictionary" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"mealDictionary"]) {
        [self updateCircles];
    }
}

- (void)updateCircles {
    NSArray *circleViews = [self.circlesStackView arrangedSubviews];
    for (UIView *view in circleViews) {
        [self.circlesStackView removeArrangedSubview:view];
    }
    [self.circlesStackView.leftAnchor constraintEqualToAnchor:super.insetBackgroundView.leftAnchor constant:15.0].active = YES;
    [self.circlesStackView.topAnchor constraintEqualToAnchor:super.insetBackgroundView.topAnchor constant:5.0].active = YES;
    [self.circlesStackView.rightAnchor constraintEqualToAnchor:super.insetBackgroundView.rightAnchor constant:-15.0].active = YES;
    [self.circlesStackView.bottomAnchor constraintEqualToAnchor:super.insetBackgroundView.bottomAnchor constant:-5.0].active = YES;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *foodTypes = [appDelegate fetchFoodTypes];
    for (FoodType *foodType in foodTypes) {
        FoodTypeCircle *circle = [FoodTypeCircle new];
        circle.letterTitle = [foodType.name substringToIndex:1];
        NSNumber *hasEatenFoodTypeNumber = [self.mealDictionary valueForKey:foodType.name];
        if (hasEatenFoodTypeNumber.boolValue) {
            circle.color = [NSKeyedUnarchiver unarchivedObjectOfClass:UIColor.class fromData:foodType.color error:nil];
        } else {
            circle.color = UIColor.grayColor;
        }
        [self.circlesStackView addArrangedSubview:circle];
    }
}


@end
