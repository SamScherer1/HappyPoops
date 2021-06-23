//
//  SAMPoopCell.m
//  HappyPoops
//
//  Created by Samuel Scherer on 3/17/21.
//  Copyright © 2021 SamuelScherer. All rights reserved.
//

#import "SAMPoopCell.h"

@interface SAMPoopCell ()

@property UILabel *ratingLabel;
@property NSLayoutConstraint *barWidthConstraint;
@property UIView *ratingBarBackground;
@property UIView *ratingBar;

@end

@implementation SAMPoopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setQuality:(NSInteger)quality {
    self.ratingLabel.text = [NSString stringWithFormat:@"%lu",quality];
    self.barWidthConstraint.active = NO;
    
    // Show a tiny bit of bar for 0 so you can see the red
    CGFloat barWidthMultiplier = quality == 0 ? 0.05 : quality / 10.0;
    
    self.barWidthConstraint = [self.ratingBar.widthAnchor constraintEqualToAnchor:self.ratingBarBackground.widthAnchor
                                                                       multiplier:barWidthMultiplier
                                                                         constant:0];
    self.barWidthConstraint.active = YES;
    if (quality < 4) {
        self.ratingBar.backgroundColor = UIColor.redColor;
    } else if (quality >= 4 && quality < 7) {
        self.ratingBar.backgroundColor = UIColor.orangeColor;
    } else {
        self.ratingBar.backgroundColor = UIColor.greenColor;
    }
    
    if (quality == 10) {
        self.ratingBar.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner | kCALayerMaxXMinYCorner | kCALayerMaxXMaxYCorner;
    } else {
        self.ratingBar.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner;
    }
}


- (void)setupView {
    [super setupView];
    
    [super.insetBackgroundView.leftAnchor constraintEqualToAnchor:super.leftAnchor constant:150].active = YES;
    [super.insetBackgroundView.rightAnchor constraintEqualToAnchor:super.rightAnchor constant:-15].active = YES;
    
    self.ratingBarBackground = [UIView new];
    self.ratingBarBackground.translatesAutoresizingMaskIntoConstraints = NO;
    self.ratingBarBackground.backgroundColor = UIColor.grayColor;
    self.ratingBarBackground.layer.cornerRadius = 10;
    
    [super.insetBackgroundView addSubview:self.ratingBarBackground];
    [self.ratingBarBackground.leftAnchor constraintEqualToAnchor:super.insetBackgroundView.leftAnchor constant:5.0].active = YES;
    [self.ratingBarBackground.rightAnchor constraintEqualToAnchor:super.insetBackgroundView.rightAnchor constant:-5.0].active = YES;
    [self.ratingBarBackground.topAnchor constraintEqualToAnchor:super.insetBackgroundView.topAnchor constant:5.0].active = YES;
    [self.ratingBarBackground.bottomAnchor constraintEqualToAnchor:super.insetBackgroundView.bottomAnchor constant:-5.0].active = YES;
    
    self.ratingBar = [UIView new];
    self.ratingBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.ratingBar.backgroundColor = UIColor.greenColor;
    [super.insetBackgroundView addSubview:self.ratingBar];
    [self.ratingBar.leftAnchor constraintEqualToAnchor:self.ratingBarBackground.leftAnchor].active = YES;
    [self.ratingBar.topAnchor constraintEqualToAnchor:self.ratingBarBackground.topAnchor].active = YES;
    [self.ratingBar.bottomAnchor constraintEqualToAnchor:self.ratingBarBackground.bottomAnchor].active = YES;
    self.barWidthConstraint = [self.ratingBar.widthAnchor constraintEqualToAnchor:self.ratingBarBackground.widthAnchor multiplier:0.7 constant:0];
    self.barWidthConstraint.active = YES;
    self.ratingBar.layer.cornerRadius = 10;
    self.ratingBar.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner;
    //self.ratingBar.maskView = self.ratingBarBackground;
    
    self.ratingLabel = [UILabel new];
    self.ratingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.ratingLabel.textColor = UIColor.blackColor;
    self.ratingLabel.font = [UIFont systemFontOfSize:20];
    [super.insetBackgroundView addSubview:self.ratingLabel];
    [self.ratingLabel.centerXAnchor constraintEqualToAnchor:self.ratingBarBackground.centerXAnchor].active = YES;
    [self.ratingLabel.centerYAnchor constraintEqualToAnchor:self.ratingBarBackground.centerYAnchor].active = YES;
}

@end
