//
//  SAMAddTaskViewController.h
//  HappyPoops
//
//  Created by Samuel Scherer on 7/28/19.
//  Copyright © 2019 SamuelScherer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SAMTrackViewController;

NS_ASSUME_NONNULL_BEGIN

@interface SAMAddEventViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSString *taskTitle;
@property (strong, nonatomic) SAMTrackViewController *trackViewController;

@property (strong, nonatomic) UITextField *titleTextField;

- (void)doneConfiguringTask;

@end

NS_ASSUME_NONNULL_END
