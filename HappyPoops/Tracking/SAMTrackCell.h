//
//  MRTableViewCell.h
//  PlanningApp
//
//  Created by Samuel Scherer on 7/13/19.
//  Copyright © 2019 Samuel Scherer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAMTrackCell : UITableViewCell

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIImageView *completionIconView;
@property (strong, nonatomic) UIView *insetBackgroundView;

- (void)setupView;

@end

NS_ASSUME_NONNULL_END
