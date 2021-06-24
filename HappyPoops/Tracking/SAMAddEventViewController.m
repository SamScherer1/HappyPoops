//
//  SAMAddTaskViewController.m
//  Effective
//
//  Created by Samuel Scherer on 7/28/19.
//  Copyright © 2019 SamuelScherer. All rights reserved.
//

#import "SAMAddEventViewController.h"
#import "SAMTrackViewController.h"
#import "UIColor+SAMColors.h"
#import <MapKit/MapKit.h>
#import "HappyPoops-Swift.h"

@interface SAMAddEventViewController ()

@property (strong, nonatomic) UILabel *eventPropertiesLabel;
@property (strong, nonatomic) UISegmentedControl *eventTypeControl;
@property (strong, nonatomic) UILabel *poopRatingLabel;
@property (strong, nonatomic) UIPickerView *poopRatingPicker;
@property (strong, nonatomic) NSLayoutConstraint *timeToMealConstraint;
@property (strong, nonatomic) NSLayoutConstraint *timeToPoopConstraint;
@property (strong, nonatomic) UIDatePicker *datePicker;

@property (strong, nonatomic) NSMutableArray *foodTypeLabels;
@property (strong, nonatomic) NSMutableArray *foodTypeSwitches;
@property (strong, nonatomic) NSArray *oneToTenArray;
@property (strong, nonatomic) NSArray *foodTypeArray;
@property (assign, nonatomic) NSInteger currentRating;

@end

@implementation SAMAddEventViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:scrollView];
    [scrollView.contentLayoutGuide.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor].active = YES;
    [scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [scrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
    [scrollView.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor].active = YES;
    [scrollView.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor].active = YES;
    
    UILabel *eventTypeLabel = [UILabel new];
    eventTypeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:eventTypeLabel];
    eventTypeLabel.textColor = UIColor.whiteColor;
    eventTypeLabel.font = [UIFont systemFontOfSize:22.0];
    eventTypeLabel.text = @"Event Type:";
    [eventTypeLabel.topAnchor constraintEqualToAnchor:scrollView.topAnchor constant:15.0].active = YES;
    [eventTypeLabel.leftAnchor constraintEqualToAnchor:scrollView.leftAnchor constant:15.0].active = YES;
    [eventTypeLabel.rightAnchor constraintEqualToAnchor:scrollView.rightAnchor constant:15.0].active = YES;
    [eventTypeLabel.heightAnchor constraintEqualToConstant:25.0].active = YES;
    
    
    self.eventTypeControl = [[UISegmentedControl alloc] initWithItems:@[@"Meal", @"Poop"]];
    self.eventTypeControl.translatesAutoresizingMaskIntoConstraints = NO;

    [self.eventTypeControl setTitleTextAttributes:@{ NSForegroundColorAttributeName : UIColor.whiteColor }
                                         forState:UIControlStateNormal];
    [self.eventTypeControl setTitleTextAttributes:@{ NSForegroundColorAttributeName : UIColor.blackColor }
                                         forState:UIControlStateSelected];
    
    self.eventTypeControl.selectedSegmentIndex = 0;
    [scrollView addSubview:self.eventTypeControl];
    [self.eventTypeControl.leftAnchor constraintEqualToAnchor:scrollView.leftAnchor constant:30.0].active = YES;
    [self.eventTypeControl.topAnchor constraintEqualToAnchor:eventTypeLabel.bottomAnchor constant:15.0].active = YES;
    [self.eventTypeControl.rightAnchor constraintEqualToAnchor:scrollView.rightAnchor constant:-15.0].active = YES;
    [self.eventTypeControl.heightAnchor constraintEqualToConstant:25.0].active = YES;
    
    [self.eventTypeControl addTarget:self
                         action:@selector(eventTypeChanged)
               forControlEvents:UIControlEventValueChanged];
    
    self.eventPropertiesLabel = [self labelWithTitle:@"Meal Properties:"
                                         belowAnchor:self.eventTypeControl.bottomAnchor
                                         inSuperview:scrollView];
    self.eventPropertiesLabel.font = [UIFont systemFontOfSize:22.0];
    [self.eventPropertiesLabel.leftAnchor constraintEqualToAnchor:scrollView.leftAnchor constant:15.0].active = YES;
    
    
    //Meal UI Elements
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.foodTypeArray = [appDelegate fetchFoodTypes];
    NSLayoutAnchor *belowAnchor = self.eventPropertiesLabel.bottomAnchor;
    self.foodTypeLabels = [NSMutableArray new];
    self.foodTypeSwitches = [NSMutableArray new];
    for (FoodType *foodType in self.foodTypeArray) {
        UILabel *foodTypeLabel = [self labelWithTitle:foodType.name
                                          belowAnchor:belowAnchor
                                          inSuperview:scrollView];
        [foodTypeLabel.leftAnchor constraintEqualToAnchor:scrollView.leftAnchor constant:30.0].active = YES;
        [self.foodTypeLabels addObject:foodTypeLabel];
        
        UISwitch *foodTypeSwitch = [UISwitch new];
        foodTypeSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        [scrollView addSubview:foodTypeSwitch];
        [foodTypeSwitch.centerYAnchor constraintEqualToAnchor:foodTypeLabel.centerYAnchor].active = YES;
        [foodTypeSwitch.rightAnchor constraintEqualToAnchor:scrollView.rightAnchor constant:-15.0].active = YES;
        [self.foodTypeSwitches addObject:foodTypeSwitch];
        
        belowAnchor = foodTypeLabel.bottomAnchor;
    }
    
    // Poop UI Elements
    self.poopRatingLabel = [self labelWithTitle:@"Poop Rating?"
                                    belowAnchor:self.eventPropertiesLabel.bottomAnchor
                                    inSuperview:scrollView];
    [self.poopRatingLabel.leftAnchor constraintEqualToAnchor:scrollView.leftAnchor constant:30.0].active = YES;
    self.poopRatingLabel.hidden = YES;
    
    self.poopRatingPicker = [UIPickerView new];
    self.poopRatingPicker.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:self.poopRatingPicker];
    self.poopRatingPicker.dataSource = self;
    self.poopRatingPicker.delegate = self;
    self.oneToTenArray = @[ @0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @10];
    [scrollView addSubview:self.poopRatingPicker];
    [self.poopRatingPicker.leftAnchor constraintEqualToAnchor:self.poopRatingLabel.rightAnchor constant:5.0].active = YES;
    [self.poopRatingPicker.centerYAnchor constraintEqualToAnchor:self.poopRatingLabel.centerYAnchor constant:15.0].active = YES;
    [self.poopRatingPicker.rightAnchor constraintEqualToAnchor:scrollView.rightAnchor constant:-15.0].active = YES;
    [self.poopRatingPicker.heightAnchor constraintEqualToConstant:100.0].active = YES;
    self.poopRatingPicker.hidden = YES;

    
    self.datePicker = [UIDatePicker new];
    self.datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:self.datePicker];
    
    self.timeToMealConstraint = [self.datePicker.topAnchor constraintEqualToAnchor:belowAnchor constant:15.0];
    self.timeToPoopConstraint = [self.datePicker.topAnchor constraintEqualToAnchor:self.poopRatingPicker.bottomAnchor constant:15.0];
    self.timeToMealConstraint.active = YES;
    self.timeToPoopConstraint.active = NO;
    
    [self.datePicker.rightAnchor constraintEqualToAnchor:scrollView.rightAnchor constant:-15.0].active = YES;
    [self.datePicker.heightAnchor constraintEqualToConstant:100.0].active = YES;
    self.datePicker.date = [NSDate date];
}

- (UILabel *)labelWithTitle:(NSString *)title belowAnchor:(NSLayoutAnchor *)belowAnchor inSuperview:(UIView *)inSuperview {
    UILabel *label = [UILabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [inSuperview addSubview:label];
    label.text = title;
    label.textColor = UIColor.whiteColor;
    [label.topAnchor constraintEqualToAnchor:belowAnchor constant:15.0].active = YES;
    return label;
}

- (void)eventTypeChanged {
    if (self.eventTypeControl.selectedSegmentIndex == 0) {
        self.eventPropertiesLabel.text = @"Meal Properties:";
        self.poopRatingLabel.hidden = YES;
        self.poopRatingPicker.hidden = YES;
        for (UILabel *foodTypeLabel in self.foodTypeLabels) {
            foodTypeLabel.hidden = NO;
        }
        for (UISwitch *foodTypeSwitch in self.foodTypeSwitches) {
            foodTypeSwitch.hidden = NO;
        }
        
        self.timeToMealConstraint.active = YES;
        self.timeToPoopConstraint.active = NO;
    } else {
        self.eventPropertiesLabel.text = @"Poop Properties:";
        self.poopRatingLabel.hidden = NO;
        self.poopRatingPicker.hidden = NO;
        for (UILabel *foodTypeLabel in self.foodTypeLabels) {
            foodTypeLabel.hidden = YES;
        }
        for (UISwitch *foodTypeSwitch in self.foodTypeSwitches) {
            foodTypeSwitch.hidden = YES;
        }
        
        self.timeToMealConstraint.active = NO;
        self.timeToPoopConstraint.active = YES;
    }
}

- (void)doneConfiguringTask {
    if (self.trackViewController == nil) {
        NSLog(@"Couldn't configure task, can't reference trackVC");
        return;
    }
    
    if (self.eventTypeControl.selectedSegmentIndex ==  0) {
        // Add Meal
        NSMutableDictionary *foodTypesInMeal = [NSMutableDictionary new];
        int index = 0;
        for (FoodType *foodType in self.foodTypeArray) {
            UISwitch *foodTypeSwitch = [self.foodTypeSwitches objectAtIndex:index];
            [foodTypesInMeal setObject:@(foodTypeSwitch.isOn) forKey:foodType.name];
            index ++;
        }
        [self.trackViewController addMealWithFoodTypes:foodTypesInMeal andCompletionDate:self.datePicker.date];
    } else {
        //Add Poop
        [self.trackViewController addPoopWithRating:self.currentRating andCompletionDate:self.datePicker.date];
    }
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.oneToTenArray.count;
}

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *numberAsString = [NSString stringWithFormat:@"%lu", row];
    return [self attributedTitleFromString:numberAsString];
}

- (NSAttributedString *)attributedTitleFromString:(NSString *)string {
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange stringRange = NSMakeRange(0, string.length);
    [attributedTitle addAttribute:NSForegroundColorAttributeName value:UIColor.whiteColor range:stringRange];
    return attributedTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.currentRating = row;
}


@end
