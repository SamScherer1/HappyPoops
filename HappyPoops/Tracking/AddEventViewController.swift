//
//  AddEventViewController.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 6/28/21.
//

import Foundation

class AddEventViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var taskTitle = "Event Title..."
    @objc var trackViewController : TrackViewController?//Turn this into a delegate
    var titleTextField = UITextField()
    var eventPropertiesLabel = UILabel()
    
    var eventTypeControl = UISegmentedControl(items: ["Meal", "Poop"])
    var poopRatingLabel = UILabel()
    var poopRatingPicker = UIPickerView()
    var timeToMealConstraint = NSLayoutConstraint()
    var timeToPoopConstraint = NSLayoutConstraint()
    var datePicker = UIDatePicker()
    
    var foodTypeLabels = [UILabel]()
    var foodTypeSwitches = [UISwitch]()
    let zeroToTenArray = 0...10
    var foodTypeArray = [FoodType]()
    
    var currentRating = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true

        let eventTypeLabel = UILabel()
        eventTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(eventTypeLabel)
        eventTypeLabel.textColor = .white
        eventTypeLabel.font = UIFont.systemFont(ofSize: 22.0)
        eventTypeLabel.text = "Event Type:"
        eventTypeLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15.0).isActive = true
        eventTypeLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 15.0).isActive = true
        eventTypeLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 15.0).isActive = true
        eventTypeLabel.heightAnchor.constraint(equalToConstant: 25.0).isActive = true

        self.eventTypeControl.translatesAutoresizingMaskIntoConstraints = false

        self.eventTypeControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white],
                                                     for: .normal)
        self.eventTypeControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black],
                                                     for: .selected)

        self.eventTypeControl.selectedSegmentIndex = 0
        scrollView.addSubview(self.eventTypeControl)
        self.eventTypeControl.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 30.0).isActive = true
        self.eventTypeControl.topAnchor.constraint(equalTo: eventTypeLabel.bottomAnchor, constant: 15.0).isActive = true
        self.eventTypeControl.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -15.0).isActive = true
        self.eventTypeControl.heightAnchor.constraint(equalToConstant: 25.0).isActive = true

        self.eventTypeControl.addTarget(self, action: #selector(eventTypeChanged), for: .valueChanged)

        self.eventPropertiesLabel = self.label(with: "Meal Properties:",
                                               belowAnchor: self.eventTypeControl.bottomAnchor,
                                               in: scrollView)
        self.eventPropertiesLabel.font = UIFont.systemFont(ofSize: 22.0)
        self.eventPropertiesLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 15.0).isActive = true
//
//
        //Meal UI Elements
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        self.foodTypeArray = appDelegate.fetchFoodTypes()! //TODO: reconsider ! unwrap
        
        var belowAnchor = self.eventPropertiesLabel.bottomAnchor
        for foodType in self.foodTypeArray {
            let foodTypeLabel = self.label(with: foodType.name!, belowAnchor: belowAnchor, in: scrollView)//TODO: reconsider ! unwrap
            foodTypeLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 30.0).isActive = true
            self.foodTypeLabels.append(foodTypeLabel)

            let foodTypeSwitch = UISwitch()
            foodTypeSwitch.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(foodTypeSwitch)
            foodTypeSwitch.centerYAnchor.constraint(equalTo: foodTypeLabel.centerYAnchor).isActive = true
            foodTypeSwitch.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -15.0).isActive = true
            self.foodTypeSwitches.append(foodTypeSwitch)

            //Reset anchor to place the next label and switch below the ones just created.
            belowAnchor = foodTypeLabel.bottomAnchor
        }

        // Poop UI Elements
        self.poopRatingLabel = self.label(with: "Poop Rating:",
                                          belowAnchor: self.eventPropertiesLabel.bottomAnchor,
                                          in: scrollView)
        self.poopRatingLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 30.0).isActive = true
        self.poopRatingLabel.isHidden = true

        self.poopRatingPicker.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(self.poopRatingPicker)
        self.poopRatingPicker.dataSource = self
        self.poopRatingPicker.delegate = self
        
        scrollView.addSubview(self.poopRatingPicker)
        self.poopRatingPicker.leftAnchor.constraint(equalTo: self.poopRatingLabel.rightAnchor, constant: 5.0).isActive = true
        self.poopRatingPicker.centerYAnchor.constraint(equalTo: self.poopRatingLabel.centerYAnchor, constant: 15.0).isActive = true
        self.poopRatingPicker.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -15.0).isActive = true
        self.poopRatingPicker.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        self.poopRatingPicker.isHidden = true

        self.datePicker.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(self.datePicker)
//
        self.timeToMealConstraint = self.datePicker.topAnchor.constraint(equalTo: belowAnchor, constant: 15.0)
        self.timeToPoopConstraint = self.datePicker.topAnchor.constraint(equalTo: self.poopRatingPicker.bottomAnchor, constant: 15.0)
        self.timeToMealConstraint.isActive = true
        self.timeToPoopConstraint.isActive = false
//
        self.datePicker.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -15.0).isActive = true
        self.datePicker.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        self.datePicker.date = Date()//TODO: does this correctly get today's date?
    }

    func label(with title:String, belowAnchor:NSLayoutAnchor<NSLayoutYAxisAnchor>, in superview:UIView) -> UILabel{
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(label)
        label.text = title
        label.textColor = .white
        label.topAnchor.constraint(equalTo: belowAnchor, constant: 15.0).isActive = true
        return label
    }

    @IBAction func eventTypeChanged() {
        if self.eventTypeControl.selectedSegmentIndex == 0 {
            self.eventPropertiesLabel.text = "Meal Properties:"
            self.poopRatingLabel.isHidden = true
            self.poopRatingPicker.isHidden = true
            
            self.setFoodTypeLabelsAndSwitches(hidden:false)

            self.timeToMealConstraint.isActive = true
            self.timeToPoopConstraint.isActive = false
        } else {
            self.eventPropertiesLabel.text = "Poop Properties:"
            self.poopRatingLabel.isHidden = false
            self.poopRatingPicker.isHidden = false

            self.setFoodTypeLabelsAndSwitches(hidden: true)
            
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

    @IBAction func doneConfiguringEvent() {
        //Again, use a delegate called AddEventViewControllerDelegate, not a simple reference
        guard let trackViewController = self.trackViewController else {
            NSLog("Couldn't find TrackViewController")
            return
        }

        if self.eventTypeControl.selectedSegmentIndex == 0 {
            // Add Meal
            var foodTypesInMeal = [String : Bool]()
            for (index, foodType) in self.foodTypeArray.enumerated() {
                foodTypesInMeal[foodType.name!] = foodTypeSwitches[index].isOn
            }
            trackViewController.addMeal(with: foodTypesInMeal, date: self.datePicker.date)
        } else {
            //Add Poop
            trackViewController.addPoop(with: self.currentRating, date: self.datePicker.date)
        }
        
        self.navigationController?.popViewController(animated: true)
    }


    
    //MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedTitle = NSMutableAttributedString(string: String(row))
        let stringRange = NSMakeRange(0, String(row).count)
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
