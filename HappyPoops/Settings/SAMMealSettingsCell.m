//
//  SAMMealSettingsCell.m
//  HappyPoops
//
//  Created by Samuel Scherer on 3/25/21.
//  Copyright © 2021 SamuelScherer. All rights reserved.
//

#import "SAMMealSettingsCell.h"
#import "HappyPoops-Swift.h"

@interface SAMMealSettingsCell()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) FoodTypeCircle *foodTypeCircle;

@end

@implementation SAMMealSettingsCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setupView];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    [self setupView];
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setupView];
    return self;
}

- (void)setupView {
    self.titleLabel = [UILabel new];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:15.0].active = YES;
    [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:5.0].active = YES;
    self.titleLabel.textColor = UIColor.whiteColor;
    
    self.foodTypeCircle = [FoodTypeCircle new];
    self.foodTypeCircle.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.foodTypeCircle];
    [self.foodTypeCircle.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    [self.foodTypeCircle.heightAnchor constraintEqualToAnchor:self.contentView.heightAnchor multiplier:0.85].active = YES;
    [self.foodTypeCircle.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-15.0].active = YES;
    
    [self addObserver:self forKeyPath:@"foodType" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"foodType"]) {
        self.titleLabel.text = self.foodType.name;
        self.foodTypeCircle.letterTitle = [self.foodType.name substringToIndex:1];
        UIColor *foodTypeColor = [NSKeyedUnarchiver unarchivedObjectOfClass:UIColor.class
                                                                   fromData:self.foodType.color
                                                                      error:nil];
        self.foodTypeCircle.color = foodTypeColor;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
