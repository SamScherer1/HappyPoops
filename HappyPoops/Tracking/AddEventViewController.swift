//
//  AddEventViewController.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 6/28/21.
//

import Foundation

class AddEventViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var taskTitle = "Event Title..."
    var trackViewController : TrackViewController?//Turn this into a delegate
    var titleTextField = UITextField()
    var eventPropertiesLabel = UILabel()
    
    //self.eventTypeControl = [[UISegmentedControl alloc] initWithItems:@[@"Meal", @"Poop"]];
    var eventTypeControl = UISegmentedControl(items: ["Meal", "Poop"])
    var poopRatingLabel = UILabel()
    var poopRatingPicker = UIPickerView()
    //@property (strong, nonatomic) NSLayoutConstraint *timeToMealConstraint;
    var timeToMealConstraint = NSLayoutConstraint()
    //@property (strong, nonatomic) NSLayoutConstraint *timeToPoopConstraint;
    var timeToPoopConstraint = NSLayoutConstraint()
    //@property (strong, nonatomic) UIDatePicker *datePicker;
    var datePicker = UIDatePicker()
    
    //@property (strong, nonatomic) NSMutableArray *foodTypeLabels;
    var foodTypeLabels = [UILabel]()
    //@property (strong, nonatomic) NSMutableArray *foodTypeSwitches;
    var foodTypeSwitches = [UISwitch]()
    //@property (strong, nonatomic) NSArray *zeroToTenArray;
    let zeroToTenArray = [0...10]
    //@property (strong, nonatomic) NSArray *foodTypeArray;
    var foodTypeArray = [FoodType]()
    
    //@property (assign, nonatomic) NSInteger currentRating;
    var currentRating = 0

    override func viewDidLoad() {
//    [super viewDidLoad];
        super.viewDidLoad()
//    self.view.backgroundColor = [UIColor blackColor];
        self.view.backgroundColor = .black
//
//    UIScrollView *scrollView = [UIScrollView new];
        let scrollView = UIScrollView()
//    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        scrollView.translatesAutoresizingMaskIntoConstraints = false
//    [self.view addSubview:scrollView];
        self.view.addSubview(scrollView)
//    [scrollView.contentLayoutGuide.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor].active = YES;
        scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true
//    [scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
        scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
//    [scrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
        scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//    [scrollView.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor].active = YES;
        scrollView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
//    [scrollView.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor].active = YES;
        scrollView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
//
//    UILabel *eventTypeLabel = [UILabel new];
        let eventTypeLabel = UILabel()
//    eventTypeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        eventTypeLabel.translatesAutoresizingMaskIntoConstraints = false
//    [scrollView addSubview:eventTypeLabel];
        scrollView.addSubview(eventTypeLabel)
//    eventTypeLabel.textColor = UIColor.whiteColor;
        eventTypeLabel.textColor = .white
//    eventTypeLabel.font = [UIFont systemFontOfSize:22.0];
        eventTypeLabel.font = UIFont.systemFont(ofSize: 22.0)
//    eventTypeLabel.text = @"Event Type:";
        eventTypeLabel.text = "Event Type:"
//    [eventTypeLabel.topAnchor constraintEqualToAnchor:scrollView.topAnchor constant:15.0].active = YES;
        eventTypeLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15.0).isActive = true
//    [eventTypeLabel.leftAnchor constraintEqualToAnchor:scrollView.leftAnchor constant:15.0].active = YES;
        eventTypeLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 15.0).isActive = true
//    [eventTypeLabel.rightAnchor constraintEqualToAnchor:scrollView.rightAnchor constant:15.0].active = YES;
        eventTypeLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 15.0).isActive = true
//    [eventTypeLabel.heightAnchor constraintEqualToConstant:25.0].active = YES;
        eventTypeLabel.heightAnchor.constraint(equalToConstant: 25.0).isActive = true

        self.eventTypeControl.translatesAutoresizingMaskIntoConstraints = false
        
//    [self.eventTypeControl setTitleTextAttributes:@{ NSForegroundColorAttributeName : UIColor.whiteColor }
//                                         forState:UIControlStateNormal];
        self.eventTypeControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white],
                                                     for: .normal)
//    [self.eventTypeControl setTitleTextAttributes:@{ NSForegroundColorAttributeName : UIColor.blackColor }
//                                         forState:UIControlStateSelected];
        self.eventTypeControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black],
                                                     for: .selected)
//
//    self.eventTypeControl.selectedSegmentIndex = 0;
        self.eventTypeControl.selectedSegmentIndex = 0
//    [scrollView addSubview:self.eventTypeControl];
        scrollView.addSubview(self.eventTypeControl)
//    [self.eventTypeControl.leftAnchor constraintEqualToAnchor:scrollView.leftAnchor constant:30.0].active = YES;
        self.eventTypeControl.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 30.0).isActive = true
//    [self.eventTypeControl.topAnchor constraintEqualToAnchor:eventTypeLabel.bottomAnchor constant:15.0].active = YES;
        self.eventTypeControl.topAnchor.constraint(equalTo: eventTypeLabel.bottomAnchor, constant: 15.0).isActive = true
//    [self.eventTypeControl.rightAnchor constraintEqualToAnchor:scrollView.rightAnchor constant:-15.0].active = YES;
        self.eventTypeControl.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -15.0).isActive = true
//    [self.eventTypeControl.heightAnchor constraintEqualToConstant:25.0].active = YES;
        self.eventTypeControl.heightAnchor.constraint(equalToConstant: 25.0).isActive = true

        self.eventTypeControl.addTarget(self, action: #selector(eventTypeChanged), for: .valueChanged)
//
//    self.eventPropertiesLabel = [self labelWithTitle:@"Meal Properties:"
//                                         belowAnchor:self.eventTypeControl.bottomAnchor
//                                         inSuperview:scrollView];
        self.eventPropertiesLabel = self.label(with: "Meal Properties:",
                                               belowAnchor: self.eventTypeControl.bottomAnchor,
                                               in: scrollView)
//    self.eventPropertiesLabel.font = [UIFont systemFontOfSize:22.0];
        self.eventPropertiesLabel.font = UIFont.systemFont(ofSize: 22.0)
//    [self.eventPropertiesLabel.leftAnchor constraintEqualToAnchor:scrollView.leftAnchor constant:15.0].active = YES;
        self.eventPropertiesLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 15.0).isActive = true
//
//
        //Meal UI Elements
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        self.foodTypeArray = appDelegate.fetchFoodTypes()! //TODO: reconsider ! unwrap
        
//    NSLayoutAnchor *belowAnchor = self.eventPropertiesLabel.bottomAnchor;
        var belowAnchor = self.eventPropertiesLabel.bottomAnchor
//    for (FoodType *foodType in self.foodTypeArray) {
        for foodType in self.foodTypeArray {
//        UILabel *foodTypeLabel = [self labelWithTitle:foodType.name
//                                          belowAnchor:belowAnchor
//                                          inSuperview:scrollView];
            let foodTypeLabel = self.label(with: foodType.name!, belowAnchor: belowAnchor, in: scrollView)//TODO: reconsider ! unwrap
//        [foodTypeLabel.leftAnchor constraintEqualToAnchor:scrollView.leftAnchor constant:30.0].active = YES;
            foodTypeLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 30.0).isActive = true
//        [self.foodTypeLabels addObject:foodTypeLabel];
            self.foodTypeLabels.append(foodTypeLabel)
//
//        UISwitch *foodTypeSwitch = [UISwitch new];
            let foodTypeSwitch = UISwitch()
//        foodTypeSwitch.translatesAutoresizingMaskIntoConstraints = NO;
            foodTypeSwitch.translatesAutoresizingMaskIntoConstraints = false
//        [scrollView addSubview:foodTypeSwitch];
            scrollView.addSubview(foodTypeSwitch)
//        [foodTypeSwitch.centerYAnchor constraintEqualToAnchor:foodTypeLabel.centerYAnchor].active = YES;
            foodTypeSwitch.centerYAnchor.constraint(equalTo: foodTypeLabel.centerYAnchor).isActive = true
//        [foodTypeSwitch.rightAnchor constraintEqualToAnchor:scrollView.rightAnchor constant:-15.0].active = YES;
            foodTypeSwitch.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -15.0).isActive = true
//        [self.foodTypeSwitches addObject:foodTypeSwitch];
            self.foodTypeSwitches.append(foodTypeSwitch)
//
            //Reset anchor to place the next label and switch below the ones just created.
            belowAnchor = foodTypeLabel.bottomAnchor
        }
//
        // Poop UI Elements
//    self.poopRatingLabel = [self labelWithTitle:@"Poop Rating?"
//                                    belowAnchor:self.eventPropertiesLabel.bottomAnchor
//                                    inSuperview:scrollView];
        self.poopRatingLabel = self.label(with: "Poop Rating",
                                          belowAnchor: self.eventPropertiesLabel.bottomAnchor,
                                          in: scrollView)
//    [self.poopRatingLabel.leftAnchor constraintEqualToAnchor:scrollView.leftAnchor constant:30.0].active = YES;
        self.poopRatingLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 30.0).isActive = true
//    self.poopRatingLabel.hidden = YES;
        self.poopRatingLabel.isHidden = true
//
        self.poopRatingPicker.translatesAutoresizingMaskIntoConstraints = false
//    [scrollView addSubview:self.poopRatingPicker];
        scrollView.addSubview(self.poopRatingPicker)
//    self.poopRatingPicker.dataSource = self;
        self.poopRatingPicker.dataSource = self
//    self.poopRatingPicker.delegate = self;
        self.poopRatingPicker.delegate = self
        
//    [scrollView addSubview:self.poopRatingPicker];
        scrollView.addSubview(self.poopRatingPicker)
//    [self.poopRatingPicker.leftAnchor constraintEqualToAnchor:self.poopRatingLabel.rightAnchor constant:5.0].active = YES;
        self.poopRatingPicker.leftAnchor.constraint(equalTo: self.poopRatingLabel.rightAnchor, constant: 5.0).isActive = true
//    [self.poopRatingPicker.centerYAnchor constraintEqualToAnchor:self.poopRatingLabel.centerYAnchor constant:15.0].active = YES;
        self.poopRatingPicker.centerYAnchor.constraint(equalTo: self.poopRatingLabel.centerYAnchor, constant: 15.0).isActive = true
//    [self.poopRatingPicker.rightAnchor constraintEqualToAnchor:scrollView.rightAnchor constant:-15.0].active = YES;
        self.poopRatingPicker.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -15.0).isActive = true
//    [self.poopRatingPicker.heightAnchor constraintEqualToConstant:100.0].active = YES;
        self.poopRatingPicker.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
//    self.poopRatingPicker.hidden = YES;
        self.poopRatingPicker.isHidden = true
//
//
        self.datePicker.translatesAutoresizingMaskIntoConstraints = false
//    [scrollView addSubview:self.datePicker];
        scrollView.addSubview(self.datePicker)
//
//    self.timeToMealConstraint = [self.datePicker.topAnchor constraintEqualToAnchor:belowAnchor constant:15.0];
        self.timeToMealConstraint = self.datePicker.topAnchor.constraint(equalTo: belowAnchor, constant: 15.0)
//    self.timeToPoopConstraint = [self.datePicker.topAnchor constraintEqualToAnchor:self.poopRatingPicker.bottomAnchor constant:15.0];
        self.timeToPoopConstraint = self.datePicker.topAnchor.constraint(equalTo: self.poopRatingPicker.bottomAnchor, constant: 15.0)
//    self.timeToMealConstraint.active = YES;
        self.timeToMealConstraint.isActive = true
//    self.timeToPoopConstraint.active = NO;
        self.timeToPoopConstraint.isActive = false
//
//    [self.datePicker.rightAnchor constraintEqualToAnchor:scrollView.rightAnchor constant:-15.0].active = YES;
        self.datePicker.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -15.0).isActive = true
//    [self.datePicker.heightAnchor constraintEqualToConstant:100.0].active = YES;
        self.datePicker.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
//    self.datePicker.date = [NSDate date];
        self.datePicker.date = Date()//TODO: does this correctly get today's date?
    }

    func label(with title:String, belowAnchor:NSLayoutAnchor<NSLayoutYAxisAnchor>, in superview:UIView) -> UILabel{
        //    UILabel *label = [UILabel new];
        let label = UILabel()
        //    label.translatesAutoresizingMaskIntoConstraints = NO;
        label.translatesAutoresizingMaskIntoConstraints = false
        //    [inSuperview addSubview:label];
        superview.addSubview(label)
        //    label.text = title;
        label.text = title
        //    label.textColor = UIColor.whiteColor;
        label.textColor = .white
        //    [label.topAnchor constraintEqualToAnchor:belowAnchor constant:15.0].active = YES;
        label.topAnchor.constraint(equalTo: belowAnchor, constant: 15.0).isActive = true
        //    return label;
        return label
    }

    @IBAction func eventTypeChanged() {
        if self.eventTypeControl.selectedSegmentIndex == 0 {
            //        self.eventPropertiesLabel.text = @"Meal Properties:";
            self.eventPropertiesLabel.text = "Meal Properties:"
            //        self.poopRatingLabel.hidden = YES;
            self.poopRatingLabel.isHidden = true
            //        self.poopRatingPicker.hidden = YES;
            self.poopRatingPicker.isHidden = true
            //        for (UILabel *foodTypeLabel in self.foodTypeLabels) {
            //            foodTypeLabel.hidden = NO;
            //        }
            self.setFoodTypeLabelsAndSwitches(hidden:false)

            //
            //        self.timeToMealConstraint.active = YES;
            //        self.timeToPoopConstraint.active = NO;
            self.timeToMealConstraint.isActive = true
            self.timeToPoopConstraint.isActive = false
        } else {
            //        self.eventPropertiesLabel.text = @"Poop Properties:";
            //        self.poopRatingLabel.hidden = NO;
            //        self.poopRatingPicker.hidden = NO;
            self.eventPropertiesLabel.text = "Poop Properties:"

            self.setFoodTypeLabelsAndSwitches(hidden: true)
            //
            //        self.timeToMealConstraint.active = NO;
            //        self.timeToPoopConstraint.active = YES;
            self.timeToMealConstraint.isActive = false
            self.timeToPoopConstraint.isActive = true
        }
    }
    
    func setFoodTypeLabelsAndSwitches(hidden:Bool) {
        for foodTypeLabel in self.foodTypeLabels {
            foodTypeLabel.isHidden = hidden
        }
        
        for foodTypeSwitch in self.foodTypeSwitches {
            foodTypeSwitch.isHidden = hidden
        }
    }
//
//- (void)doneConfiguringTask {
    func doneConfiguringTask() {
//    if (self.trackViewController == nil) {
//        NSLog(@"Couldn't configure task, can't reference trackVC");
//        return;
//    }
        //Again, use a delegate called AddEventViewControllerDelegate, not a simple reference
        guard let trackViewController = self.trackViewController else {
            NSLog("Couldn't find TrackViewController")
            return
        }
//
//    if (self.eventTypeControl.selectedSegmentIndex ==  0) {
        if self.eventTypeControl.selectedSegmentIndex == 0 {
            // Add Meal
//        NSMutableDictionary *foodTypesInMeal = [NSMutableDictionary new];
            var foodTypesInMeal = [String : Bool]()
//        int index = 0;
//        for (FoodType *foodType in self.foodTypeArray) {
//            UISwitch *foodTypeSwitch = [self.foodTypeSwitches objectAtIndex:index];
//            [foodTypesInMeal setObject:@(foodTypeSwitch.isOn) forKey:foodType.name];
//            index ++;
//        }
            for (index, foodType) in self.foodTypeArray.enumerated() {
                foodTypesInMeal[foodType.name!] = foodTypeSwitches[index].isOn
            }
            //[self.trackViewController addMealWithFoodTypes:foodTypesInMeal andCompletionDate:self.datePicker.date];
            trackViewController.addMeal(with: foodTypesInMeal, date: self.datePicker.date)
        } else {
            //Add Poop
            //[self.trackViewController addPoopWithRating:self.currentRating andCompletionDate:self.datePicker.date];
            trackViewController.addPoop(with: self.currentRating, date: self.datePicker.date)
        }

        //TODO: should animate?
        //[self.navigationController popViewControllerAnimated:NO];
        self.navigationController?.popViewController(animated: true)
    }


    
    //MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        //    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:string];
        let attributedTitle = NSMutableAttributedString(string: String(row))
        //    NSRange stringRange = NSMakeRange(0, string.length);
        let stringRange = NSMakeRange(0, String(row).count)
        //    [attributedTitle addAttribute:NSForegroundColorAttributeName value:UIColor.whiteColor range:stringRange];
        attributedTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: stringRange)
        return attributedTitle
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.zeroToTenArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentRating = row
    }
}
