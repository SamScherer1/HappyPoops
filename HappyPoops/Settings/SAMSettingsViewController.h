//
//  SAMSettingsViewController.h
//  Effective
//
//  Created by Samuel Scherer on 10/14/20.
//  Copyright © 2020 SamuelScherer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAMSettingsViewController : UIViewController <UITableViewDataSource>

- (void)addFoodTypeWithName:(NSString *)name andColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
