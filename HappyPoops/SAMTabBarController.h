//
//  SAMTabBarController.h
//  Effective
//
//  Created by Samuel Scherer on 8/6/20.
//  Copyright © 2020 SamuelScherer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SAMTrackViewController;


NS_ASSUME_NONNULL_BEGIN

@interface SAMTabBarController : UITabBarController

@property (strong, nonatomic) SAMTrackViewController *trackVC;

@end

NS_ASSUME_NONNULL_END
