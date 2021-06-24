//
//  MRTableViewController.m
//  PlanningApp
//
//  Created by Samuel Scherer on 7/13/19.
//  Copyright © 2019 Samuel Scherer. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SAMTrackViewController.h"
#import "SAMPoopCell.h"
#import "SAMMealCell.h"
#import "UIColor+SAMColors.h"
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SAMAddEventViewController.h"
#import "HappyPoops-Swift.h"

@interface SAMTrackViewController ()

@property (strong, nonatomic) UIGestureRecognizer *singleTapGestureRecognizer;
@property (strong, nonatomic) UIGestureRecognizer *doubleTapGestureRecognizer;
@property (strong, nonatomic) UIGestureRecognizer *tripleTapGestureRecognizer;

@property (strong, nonatomic) NSDate *lastTaskUpdateTime;

@end

@implementation SAMTrackViewController

- (void)loadView {
    [super loadView];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableView];
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.tableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.tableView registerClass:SAMMealCell.class forCellReuseIdentifier:@"MealCell"];
    [self.tableView registerClass:SAMPoopCell.class forCellReuseIdentifier:@"PoopCell"];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(5,0,0,0)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 60;
    
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = self.appDelegate.persistentContainer.viewContext;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsSelection = NO;
    
    self.tableView.backgroundColor = [UIColor blackColor];
    
    // Add Tap Gesture Recognizers for marking tasks as Done, Won't Do, or Revisit
    self.singleTapGestureRecognizer = [self addGestureRecognizerForTaps:1];
    self.doubleTapGestureRecognizer = [self addGestureRecognizerForTaps:2];
    self.tripleTapGestureRecognizer = [self addGestureRecognizerForTaps:3];
    
    // Make it so the recognizer with more taps doesn't call the one with fewer taps too
    [self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.doubleTapGestureRecognizer];
    [self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.tripleTapGestureRecognizer];
    [self.doubleTapGestureRecognizer requireGestureRecognizerToFail:self.tripleTapGestureRecognizer];
        
    [self.tableView setEditing:NO];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableView)
                                                 name:@"FoodTypesUpdated"
                                               object:nil];
}

- (UIGestureRecognizer *)addGestureRecognizerForTaps:(NSInteger)taps {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapsFromGestureRecognizer:)];
    tapRecognizer.numberOfTapsRequired = taps;
    [self.tableView addGestureRecognizer:tapRecognizer];
    return tapRecognizer;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.appDelegate fetchEvents].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Event *event = [self.appDelegate fetchEvents][indexPath.row];
    SAMTrackCell *cell;
    //TODO: this dictionary shouild probably be mutable for easy editing...
    NSDictionary *qualititesDictionary = [NSKeyedUnarchiver unarchivedObjectOfClass:NSDictionary.class
                                                                          fromData:event.qualitiesDictionary
                                                                             error:nil];
    if (event.isMeal) {
        SAMMealCell *mealCell = [tableView dequeueReusableCellWithIdentifier:@"MealCell" forIndexPath:indexPath];
        mealCell.mealDictionary = qualititesDictionary;
        cell = mealCell;
    } else {
        SAMPoopCell *poopCell = [tableView dequeueReusableCellWithIdentifier:@"PoopCell" forIndexPath:indexPath];
        NSNumber *quality = [qualititesDictionary objectForKey:@"rating"];
        [poopCell setQuality:quality.integerValue];
        cell = poopCell;
    }
    cell.backgroundColor = [UIColor clearColor];
    
    [cell.completionIconView setHidden:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];

    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Event *eventToDelete = [self.appDelegate fetchEvents][indexPath.row];
        // TODO: Explicitly delete the tableview cell to have a nice animation
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.managedObjectContext deleteObject:eventToDelete];
        [self.appDelegate saveContext];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EventsUpdated" object:nil];
        [self.tableView reloadData];
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    //TODO: implement reordering (add a thing to change the time when reordering too)
//    NSMutableArray *eventArray = [NSMutableArray arrayWithArray:[self.appDelegate fetchEvents]];
//    Event *fromEvent = eventArray[fromIndexPath.row];
//    [eventArray removeObjectAtIndex:fromIndexPath.row];
//    [eventArray insertObject:fromEvent atIndex:toIndexPath.row];
//    [self.appDelegate saveContext];
}

#pragma mark -

- (void)addMealWithFoodTypes:(NSDictionary *)foodTypesDictionary andCompletionDate:(NSDate *)date {
    Event *mealEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    mealEvent.date = date;
    mealEvent.isMeal = YES;
    NSData *archivedQualities = [NSKeyedArchiver archivedDataWithRootObject:foodTypesDictionary
                                                      requiringSecureCoding:NO
                                                                      error:nil];
    mealEvent.qualitiesDictionary = archivedQualities;

    [self addEvent:mealEvent];
}

- (void)addPoopWithRating:(NSInteger)rating andCompletionDate:(NSDate *)date {
    Event *poopEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    poopEvent.date = date;
    poopEvent.isMeal = NO;
    NSDictionary *qualitiesDictionary = @{ @"rating":@(rating) };
    NSData *archivedQualities = [NSKeyedArchiver archivedDataWithRootObject:qualitiesDictionary
                                                      requiringSecureCoding:NO
                                                                      error:nil];
    poopEvent.qualitiesDictionary = archivedQualities;
    [self addEvent:poopEvent];
}

- (void)addEvent:(Event*)event {
    [self dismissViewControllerAnimated:YES completion:nil];//TODO: necessary?
    [self.tableView reloadData];
    [self.appDelegate saveContext];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EventsUpdated" object:nil];
}

- (void)editTasks {
    if ([self.tableView isEditing]) {
        [self.tableView setEditing:NO];
        self.editButton.title = @"Edit";
        [self.tableView addGestureRecognizer:self.singleTapGestureRecognizer];
        [self.tableView addGestureRecognizer:self.doubleTapGestureRecognizer];
        [self.tableView addGestureRecognizer:self.tripleTapGestureRecognizer];
    } else {
        [self.tableView setEditing:YES];
        self.editButton.title = @"Done";
        [self.tableView removeGestureRecognizer:self.singleTapGestureRecognizer];
        [self.tableView removeGestureRecognizer:self.doubleTapGestureRecognizer];
        [self.tableView removeGestureRecognizer:self.tripleTapGestureRecognizer];
    }
}

- (void)reloadTableView {
    [self.tableView performSelectorOnMainThread:@selector(reloadData)
                                      withObject:nil
                                   waitUntilDone:NO];
}

- (void)presentAddTaskVC {
    SAMAddEventViewController *addTaskVC = [SAMAddEventViewController new];
    addTaskVC.trackViewController = self;
    [self presentViewController:addTaskVC animated:NO completion:nil];
}

- (void)handleTapsFromGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer {
    // Only add completion status in applicable states
    CGPoint touchPoint = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *touchPath = [self.tableView indexPathForRowAtPoint:touchPoint];
    if (touchPath.row >= [self.appDelegate fetchEvents].count || touchPath == nil) {
        return;
    }
    
    // Update Task Completion Data
    //Task *tappedTask = [self.appDelegate fetchEvents][touchPath.row];
    
//
//    // Set number for number task
//    if (tappedTask.taskCompletionType == SAMTaskTypeNumber && gestureRecognizer.numberOfTapsRequired == 1) {
//        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Input Value"
//                                                                       message:@""
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//            textField.delegate = self;
//            self.editingNumberTask = tappedTask;
//        }];
//
//        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
//                                                                style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction * action) {}];
//
//        //TODO: add cancel button
//
//        [alert addAction:defaultAction];
//        [self presentViewController:alert animated:YES completion:nil];
//    } else {
//        NSMutableArray *taskCompletionTimes = [AppDelegate fetchDateArrayForTask:tappedTask];
//
//        if (taskCompletionTimes == nil) {
//            taskCompletionTimes = [NSMutableArray new];
//        }
//
//        // If last completion date is today, remove it
//        NSDate *lastLogDate = taskCompletionTimes.lastObject;
//        if (lastLogDate != nil) {
//            if ([[NSCalendar currentCalendar] isDateInToday:lastLogDate]) {
//                [taskCompletionTimes removeObject:taskCompletionTimes.lastObject];
//            }
//        }
//
//        if (gestureRecognizer.numberOfTapsRequired == 1) {
//            [taskCompletionTimes addObject:[NSDate date]];
//        }
//
//        // UNCOMMENT TO MOCK TIME DATA TODO: use constants at top of file to control these
//        //taskCompletionTimes = [self mockedTimeArray];
//
//        [tappedTask setValue:[NSKeyedArchiver archivedDataWithRootObject:taskCompletionTimes
//                                                   requiringSecureCoding:YES
//                                                                   error:nil] forKey:@"completionTimes"];
//    }
    
    //[self.analyzeViewController.tableView reloadData];
    [self.tableView reloadData];
    
    [self.appDelegate saveContext];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"TODO: implement textFieldDidEndEditing");
//    double textAsDouble;
//    NSScanner *scanner = [NSScanner scannerWithString:textField.text];
//    BOOL success = [scanner scanDouble:&textAsDouble];
//    if (success) {
//        NSMutableArray *userInputNumbers = [NSKeyedUnarchiver unarchivedObjectOfClass:NSMutableArray.class
//                                                                             fromData:self.editingNumberTask.userInputNumbers
//                                                                                error:nil];
//        if (userInputNumbers == nil) {
//            userInputNumbers = [NSMutableArray new];
//        }
//
////        NSMutableArray *completionDates = [AppDelegate fetchDateArrayForTask:self.editingNumberTask];
////        if (completionDates.count > 0 && userInputNumbers > 0) {
////            // If there's already input today, overwrite, otherwise append
////            NSDate *latestCompletionDate = [completionDates objectAtIndex:completionDates.count - 1];
////            if ([[NSCalendar currentCalendar] isDateInToday:latestCompletionDate]) {
////                [userInputNumbers removeObjectAtIndex:userInputNumbers.count - 1];
////                [completionDates removeObjectAtIndex:completionDates.count - 1];
////            }
////        }
////
////        [completionDates addObject:[NSDate date]];
////        NSData *completionDatesData = [NSKeyedArchiver archivedDataWithRootObject:completionDates
////                                                            requiringSecureCoding:YES
////                                                                            error:nil];
////        [self.editingNumberTask setValue:completionDatesData forKey:@"completionTimes"];
////        [userInputNumbers addObject:[NSNumber numberWithDouble:textAsDouble]];
////        NSData *userInputNumbersAfter = [NSKeyedArchiver archivedDataWithRootObject:userInputNumbers
////                                                              requiringSecureCoding:YES
////                                                                              error:nil];//TODO: requiring secure coding?
//        //[self.editingNumberTask setValue:userInputNumbersAfter forKey:@"userInputNumbers"];
//
//        // UNCOMMENT TO MOCK NUMBER DATA
//        [self mockValueDataForTask:self.editingNumberTask];
//    } else {
//        NSLog(@"failed to parse userInput....");
//    }
//    NSLog(@"textField text: %@", textField.text);
//    [self.tableView reloadData];
}

- (void)mockValueDataForTask:(Event *)event {
    NSLog(@"TODO: mockValueDataForTask");
//    NSMutableDictionary *mockValueDictionary = [self mockedValueDictionary];
//    NSMutableArray *mockValueArray = [mockValueDictionary objectForKey:@"userInputNumbers"];
//    NSData *mockUserInput = [NSKeyedArchiver archivedDataWithRootObject:mockValueArray requiringSecureCoding:YES error:nil];
//    NSData *mockTimeData = [NSKeyedArchiver archivedDataWithRootObject:[mockValueDictionary objectForKey:@"completionTimes"] requiringSecureCoding:YES error:nil];
//    [self.editingNumberTask setValue:mockTimeData forKey:@"completionTimes"];
//    [self.editingNumberTask setValue:mockUserInput forKey:@"userInputNumbers"];
}

- (NSMutableDictionary *)mockedValueDictionary {
    //Mock test data:
    NSMutableArray *taskCompletionTimes = [NSMutableArray new];
    NSMutableArray *userInputTimes = [NSMutableArray new];
    //NSTimeInterval threeDays = -240800;
    NSTimeInterval dayAndABit = -89400;
    //NSTimeInterval day = -86400;

    for (int i = 40; i >= 0; i--) {
        NSDate *date = [[NSDate date] dateByAddingTimeInterval:dayAndABit * i];
        [taskCompletionTimes addObject:date];
        [userInputTimes addObject:[NSNumber numberWithInt:i]];
    }
    NSMutableDictionary *mockedValueData = [NSMutableDictionary new];
    [mockedValueData setValue:taskCompletionTimes forKey:@"completionTimes"];
    [mockedValueData setValue:userInputTimes forKey:@"userInputNumbers"];
    return mockedValueData;
}


- (NSMutableArray *)mockedTimeArray {
    //Mock test data:
    NSMutableArray *taskCompletionTimes = [NSMutableArray new];
    //NSTimeInterval threeDays = -240800;
    NSTimeInterval dayAndABit = -89400;
    //NSTimeInterval day = -86400;
    
    for (int i = 30; i >= 0; i--) {
        NSDate *date = [[NSDate date] dateByAddingTimeInterval:dayAndABit * i];
        [taskCompletionTimes addObject:date];
    }
    return taskCompletionTimes;

//    [taskCompletionTimes addObject:date0];
//    [taskCompletionTimes addObject:date1];
    //[taskCompletionTimes addObject:[NSDate date]];
}

@end


