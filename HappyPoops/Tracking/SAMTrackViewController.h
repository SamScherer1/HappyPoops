//
//  MRTableViewController.h
//  PlanningApp
//
//  Created by Samuel Scherer on 7/13/19.
//  Copyright © 2019 Samuel Scherer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SAMAddEventViewController;
@class MyDataController;
@class AppDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface SAMTrackViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) UIBarButtonItem *editButton;
@property (strong, nonatomic) MyDataController *dataController;
@property (strong, nonatomic) UITableView *tableView;

- (void)addMealWithFoodTypes:(NSDictionary *)foodTypesDictionary andCompletionDate:(NSDate *)date;
- (void)addPoopWithRating:(NSInteger)rating andCompletionDate:(NSDate *)date;
- (void)editTasks;
- (void)presentAddTaskVC;

@end

NS_ASSUME_NONNULL_END
