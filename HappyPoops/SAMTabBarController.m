//
//  SAMTabBarController.m
//  Effective
//
//  Created by Samuel Scherer on 8/6/20.
//  Copyright © 2020 SamuelScherer. All rights reserved.
//

#import "SAMTabBarController.h"
//#import "SAMAnalyzeViewController.h"
#import "SAMTrackViewController.h"
#import "SAMAddEventViewController.h"
#import "SAMSettingsViewController.h"
#import "UIColor+SAMColors.h"
#import <AudioToolbox/AudioToolbox.h>
#import "HappyPoops-Swift.h"

@interface SAMTabBarController ()

@property (strong, nonatomic) UINavigationController *trackNavigationVC;
@property (strong, nonatomic) UINavigationController *graphNavigationVC;
@property (strong, nonatomic) UINavigationController *settingsNavigationVC;
@property (strong, nonatomic) AnalyzeViewController *analyzeVC;
@property (strong, nonatomic) UIBarButtonItem *editButton;//Needs property?

@property (strong, nonatomic) SAMSettingsViewController *settingsVC;

@end

@implementation SAMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBar setBarStyle:UIBarStyleBlack];
        
    // Setup Track View Controller:
    self.trackVC = [SAMTrackViewController new];
    self.trackVC.navigationItem.title = @"Track";
    
    self.editButton = [[UIBarButtonItem alloc] initWithTitle:@" Edit "
                                                       style:UIBarButtonItemStylePlain
                                                      target:self.trackVC
                                                      action:@selector(editTasks)];
    self.trackVC.editButton = self.editButton;

//    UIBarButtonItem *addTaskButton = [[UIBarButtonItem alloc] initWithTitle:@" + "
//                                                                      style:UIBarButtonItemStylePlain
//                                                                     target:self
//                                                                     action:@selector(showAddTaskVC)];
    
    self.trackVC.navigationItem.leftBarButtonItem = self.editButton;
    
    UIImage *addImage = [UIImage systemImageNamed:@"plus"];
    
    UIBarButtonItem *addEventButton = [[UIBarButtonItem alloc] initWithImage:addImage
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(showAddTaskVC)];

    self.trackVC.navigationItem.rightBarButtonItem = addEventButton;
    
    self.trackNavigationVC = [[UINavigationController alloc] initWithRootViewController:self.trackVC];
    
    UITabBarItem *trackItem = [[UITabBarItem alloc] initWithTitle:@"Track"
                                                                image:[UIImage systemImageNamed:@"text.badge.checkmark"]
                                                                  tag:0];
    
    self.trackNavigationVC.tabBarItem = trackItem;
    self.trackNavigationVC.navigationBar.barStyle = UIBarStyleBlack;
    
    // Setup Analyze View Controller:
    self.analyzeVC = [AnalyzeViewController new];
    self.analyzeVC.navigationItem.title = @"Analyze";
    UIImage *analyzeIcon = [UIImage imageNamed:@"AnalyzeIcon"];
    CGSize thumbnailSize = CGSizeMake(30, 30);
    UIGraphicsBeginImageContextWithOptions(thumbnailSize, NO, 0.0);
    [analyzeIcon drawInRect:CGRectMake(0, 0, thumbnailSize.width, thumbnailSize.height)];
    UIImage *scaledAnalyzeIcon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UITabBarItem *analyzeItem = [[UITabBarItem alloc] initWithTitle:@"Analyze"
                                                             image:scaledAnalyzeIcon
                                                               tag:1];
    self.graphNavigationVC = [[UINavigationController alloc] initWithRootViewController:self.analyzeVC];
    self.graphNavigationVC.navigationBar.barStyle = UIBarStyleBlack;
    self.graphNavigationVC.tabBarItem = analyzeItem;
    
    
    UIBarButtonItem *editGraphButton = [[UIBarButtonItem alloc] initWithTitle:@" Edit "
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self.analyzeVC
                                                                       action:@selector(editGraphs)];
    //self.analyzeVC.editButton = editGraphButton;

    self.analyzeVC.navigationItem.leftBarButtonItem = editGraphButton;
    
    // Setup Settings View Controller:
    self.settingsVC = [SAMSettingsViewController new];
    self.settingsVC.navigationItem.title = @"Settings";
    UIImage *settingsIcon = [UIImage systemImageNamed:@"gear"];
    UITabBarItem *settingsItem = [[UITabBarItem alloc] initWithTitle:@"Settings"
                                                               image:settingsIcon
                                                                 tag:2];
    
    self.settingsNavigationVC = [[UINavigationController alloc] initWithRootViewController:self.settingsVC];
    self.settingsNavigationVC.tabBarItem = settingsItem;
    self.settingsNavigationVC.navigationBar.barStyle = UIBarStyleBlack;

    // Set tab bar view controllers:
    self.viewControllers = @[self.trackNavigationVC, self.graphNavigationVC, self.settingsNavigationVC];
}

- (void)showAddTaskVC {
    SAMAddEventViewController *addTaskVC = [SAMAddEventViewController new];
    addTaskVC.trackViewController = self.trackVC;
    addTaskVC.navigationItem.title = @"Add Event";
    
    addTaskVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                                   style:UIBarButtonItemStylePlain
                                                                                  target:addTaskVC
                                                                                  action:@selector(doneConfiguringTask)];
    
    [self.trackNavigationVC pushViewController:addTaskVC animated:NO];
}

- (void)presentNotificationWithText:(NSString *)text {
    AudioServicesPlaySystemSound (1007);
    
    UINavigationController *selectedNavController = self.selectedViewController;
    NSString *oldTitle = selectedNavController.topViewController.navigationItem.title;
    selectedNavController.topViewController.navigationItem.title = text;
    NSTimer *showNotificationTimer = [NSTimer scheduledTimerWithTimeInterval:5 repeats:NO block:^(NSTimer * _Nonnull timer) {
        selectedNavController.topViewController.navigationItem.title = oldTitle;
    }];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:showNotificationTimer forMode:NSDefaultRunLoopMode];
    
    //Reload tableview to show notification status
    [self.trackVC.tableView reloadData];
    
    NSInteger badgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    if (badgeNumber >= 0) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNumber + 1];
    } else {
        NSLog(@"something's wrong: found negative badgeNumber");
    }
}

@end