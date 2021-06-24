////
////  SAMSettingsViewController.m
////  HappyPoops
////
////  Created by Samuel Scherer on 10/14/20.
////  Copyright © 2020 SamuelScherer. All rights reserved.
////
//
//#import "SAMSettingsViewController.h"
//#import "UIColor+SAMColors.h"
////#import "SAMMealSettingsCell.h"
//#import "HappyPoops-Swift.h"
//
//@interface SAMSettingsViewController ()
//
//@property (strong, nonatomic) UISwitch *lanDashboardSwitch;
//@property (weak, nonatomic) AppDelegate *appDelegate;
//@property (strong, nonatomic) UITableView *foodTypeTableView;
//@property (strong, nonatomic) UIButton *foodTypeEditButton;
//
//@end
//
//@implementation SAMSettingsViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor blackColor];
//
//    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//
//    // Meal Properties
//    UIView *foodTypesBackground = [UIView new];
//    foodTypesBackground.translatesAutoresizingMaskIntoConstraints = NO;
//    foodTypesBackground.backgroundColor = [UIColor halfTransparentDarkColor];
//    foodTypesBackground.layer.cornerRadius = 15.0;
//    [self.view addSubview:foodTypesBackground];
//    [foodTypesBackground.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:15.0].active = YES;
//    [foodTypesBackground.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:5.0].active = YES;
//    [foodTypesBackground.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-15.0].active = YES;
//
//    UILabel *foodTypesTitleLabel = [self labelWithText:@"Food Types" andFontSize:24.0];
//    foodTypesTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [foodTypesBackground addSubview:foodTypesTitleLabel];
//    [foodTypesTitleLabel.topAnchor constraintEqualToAnchor:foodTypesBackground.topAnchor constant:15.0].active = YES;
//    [foodTypesTitleLabel.leftAnchor constraintEqualToAnchor:foodTypesBackground.leftAnchor constant:15.0].active = YES;
//    //[foodTypesTitleLabel.rightAnchor constraintEqualToAnchor:foodTypesBackground.rightAnchor constant:-15.0].active = YES;
//
//    self.foodTypeEditButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    self.foodTypeEditButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [foodTypesBackground addSubview:self.foodTypeEditButton];
//    self.foodTypeEditButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
//    [self.foodTypeEditButton setTitle:@"Edit" forState:UIControlStateNormal];
//    self.foodTypeEditButton.titleLabel.textColor = UIColor.systemBlueColor;
//    [self.foodTypeEditButton.bottomAnchor constraintEqualToAnchor:foodTypesTitleLabel.bottomAnchor].active = YES;
//    [self.foodTypeEditButton.rightAnchor constraintEqualToAnchor:foodTypesBackground.rightAnchor constant:-15.0].active = YES;
//    [self.foodTypeEditButton addTarget:self action:@selector(toggleFoodTypeEditing) forControlEvents:UIControlEventTouchUpInside];
//
//    self.foodTypeTableView = [ContentSizedTableView new];
//    self.foodTypeTableView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.foodTypeTableView.dataSource = self;
//    self.foodTypeTableView.scrollEnabled = NO;
//    self.foodTypeTableView.backgroundColor = UIColor.clearColor;
//    [self.foodTypeTableView registerClass:MealSettingsCell.class forCellReuseIdentifier:@"SettingsCell"];
//    [foodTypesBackground addSubview:self.foodTypeTableView];
//    [self.foodTypeTableView.topAnchor constraintEqualToAnchor:foodTypesTitleLabel.bottomAnchor constant:15.0].active = YES;
//    [self.foodTypeTableView.leftAnchor constraintEqualToAnchor:foodTypesBackground.leftAnchor constant:15.0].active = YES;
//    [self.foodTypeTableView.rightAnchor constraintEqualToAnchor:foodTypesBackground.rightAnchor constant:-15.0].active = YES;
//
//    self.foodTypeTableView.rowHeight = 50;
//
//    UIButton *addPropertyButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    UIImage *plusImage = [UIImage systemImageNamed:@"plus.circle.fill"];
//    [addPropertyButton setImage:plusImage forState:UIControlStateNormal];
//    addPropertyButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [foodTypesBackground addSubview:addPropertyButton];
//    [addPropertyButton.heightAnchor constraintEqualToAnchor:addPropertyButton.widthAnchor].active = YES;
//    [addPropertyButton.heightAnchor constraintEqualToConstant:20.0].active = YES;
//    [addPropertyButton.rightAnchor constraintEqualToAnchor:foodTypesBackground.rightAnchor constant:-15.0].active = YES;
//    [addPropertyButton.topAnchor constraintEqualToAnchor:self.foodTypeTableView.bottomAnchor constant:15.0].active = YES;
//    [addPropertyButton.bottomAnchor constraintEqualToAnchor:foodTypesBackground.bottomAnchor constant:-15.0].active = YES;
//    [addPropertyButton addTarget:self action:@selector(presentAddFoodTypeVC) forControlEvents:UIControlEventTouchUpInside];
//}
//
//- (void)presentAddFoodTypeVC {
//    AddFoodTypeVC *addFoodTypeVC = [AddFoodTypeVC new];
//    addFoodTypeVC.settingsVC = self;
//    [self presentViewController:addFoodTypeVC animated:NO completion:nil];
//}
//
//- (void)addFoodTypeWithName:(NSString *)name andColor:(UIColor *)color {
//    FoodType *newFoodType = [NSEntityDescription insertNewObjectForEntityForName:@"FoodType"
//                                                          inManagedObjectContext:self.appDelegate.persistentContainer.viewContext];
//    newFoodType.name = name;
//    newFoodType.color = [NSKeyedArchiver archivedDataWithRootObject:color
//                                              requiringSecureCoding:NO
//                                                              error:nil];
//    newFoodType.index = [NSUserDefaults.standardUserDefaults integerForKey:@"nextFoodTypeIndex"];
//
//    [self.appDelegate saveContext];
//    [self.foodTypeTableView reloadData];
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"FoodTypesUpdated" object:nil];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.appDelegate fetchFoodTypes].count;
//}
//
//- (void)toggleFoodTypeEditing {
//    [self.foodTypeTableView setEditing:!self.foodTypeTableView.isEditing];
//    [self.foodTypeEditButton setTitle:self.foodTypeTableView.isEditing ? @"Done" : @"Edit"
//                             forState:UIControlStateNormal];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    MealSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell" forIndexPath:indexPath];
//    cell.foodType = [[self.appDelegate fetchFoodTypes] objectAtIndex:indexPath.row];
//    cell.backgroundColor = UIColor.clearColor;
//    return cell;
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.foodTypeTableView.editing) {
//        return UITableViewCellEditingStyleDelete;
//    }
//    return UITableViewCellEditingStyleNone;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.appDelegate deleteFoodTypeAt:indexPath.row];
//        [self.foodTypeTableView reloadData];
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"FoodTypesUpdated" object:nil];
//}
//
//- (UILabel *)labelWithText:(NSString *)text andFontSize:(CGFloat)fontSize {
//    UILabel *label = [UILabel new];
//    label.translatesAutoresizingMaskIntoConstraints = NO;
//    label.text = text;
//    label.textColor = [UIColor whiteColor];
//    label.textAlignment = NSTextAlignmentLeft;
//    label.font = [UIFont systemFontOfSize:fontSize];
//    return label;
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
