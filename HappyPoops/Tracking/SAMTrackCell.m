//
//  MRTableViewCell.m
//  PlanningApp
//
//  Created by Samuel Scherer on 7/13/19.
//  Copyright © 2019 Samuel Scherer. All rights reserved.
//

#import "SAMTrackCell.h"
#import "UIColor+SAMColors.h"

@interface SAMTrackCell()

@end

@implementation SAMTrackCell

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

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setupView {
    self.insetBackgroundView = [[UIView alloc] init];
    self.insetBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.insetBackgroundView];
    
    [self.insetBackgroundView.topAnchor constraintEqualToAnchor:self.topAnchor constant:5.0].active = YES;
    [self.insetBackgroundView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-5.0].active = YES;
    
    self.insetBackgroundView.layer.cornerRadius = 15.0;
    
    self.insetBackgroundView.backgroundColor = [UIColor halfTransparentDarkColor];
    
    self.backgroundColor = [UIColor clearColor];
    
    // Setup Icon View (shows checkmark and exclamation point icons)
    self.completionIconView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"checkmark.circle.fill"]];
    self.completionIconView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.completionIconView];
    [self.completionIconView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10.0].active = YES;
    [self.completionIconView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-10.0].active = YES;
    [self.completionIconView.widthAnchor constraintEqualToAnchor:self.completionIconView.heightAnchor].active = YES;
    [self.completionIconView.widthAnchor constraintEqualToConstant:12.0].active = YES;
    
    // Setup Time Label
    self.timeLabel = [UILabel new];
    self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.timeLabel.font = [UIFont systemFontOfSize:12.0];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:self.timeLabel];
    [self.timeLabel.rightAnchor constraintEqualToAnchor:self.completionIconView.leftAnchor constant:-5].active = YES;
    [self.timeLabel.centerYAnchor constraintEqualToAnchor:self.completionIconView.centerYAnchor].active = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)didTransitionToState:(UITableViewCellStateMask)state {
    self.timeLabel.hidden = state && UITableViewCellStateShowingEditControlMask;
}


@end
