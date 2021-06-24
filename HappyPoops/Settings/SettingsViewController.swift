//
//  SettingsViewController.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 6/24/21.
//

import Foundation
import CoreData

class SettingsViewController: UIViewController, UITableViewDataSource {
    
    var foodTypesEditButton = UIButton.init(type: .system)
    var foodTypeTableView = ContentSizedTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        let foodTypesBackground = UIView()
        foodTypesBackground.translatesAutoresizingMaskIntoConstraints = false
        //    foodTypesBackground.backgroundColor = [UIColor halfTransparentDarkColor];
        foodTypesBackground.backgroundColor = .gray//TODO: use category
        //    foodTypesBackground.layer.cornerRadius = 15.0;
        foodTypesBackground.layer.cornerRadius = 15.0
        //    [self.view addSubview:foodTypesBackground];
        self.view.addSubview(foodTypesBackground)
        //    [foodTypesBackground.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:15.0].active = YES;
        foodTypesBackground.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15.0).isActive = true
        //    [foodTypesBackground.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:5.0].active = YES;
        foodTypesBackground.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5.0).isActive = true
        //    [foodTypesBackground.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-15.0].active = YES;
        foodTypesBackground.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15.0).isActive = true
        
        //    UILabel *foodTypesTitleLabel = [self labelWithText:@"Food Types" andFontSize:24.0];
        let foodTypesTitleLabel = self.label(with: "Food Types", fontSize: 24.0)
        //    foodTypesTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        foodTypesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        //    [foodTypesBackground addSubview:foodTypesTitleLabel];
        foodTypesBackground.addSubview(foodTypesTitleLabel)
        //    [foodTypesTitleLabel.topAnchor constraintEqualToAnchor:foodTypesBackground.topAnchor constant:15.0].active = YES;
        foodTypesTitleLabel.topAnchor.constraint(equalTo: foodTypesBackground.topAnchor, constant: 15.0).isActive = true
        //    [foodTypesTitleLabel.leftAnchor constraintEqualToAnchor:foodTypesBackground.leftAnchor constant:15.0].active = YES;
        foodTypesTitleLabel.leftAnchor.constraint(equalTo: foodTypesBackground.leftAnchor, constant: 15.0).isActive  = true
        //    //[foodTypesTitleLabel.rightAnchor constraintEqualToAnchor:foodTypesBackground.rightAnchor constant:-15.0].active = YES;
        foodTypesTitleLabel.rightAnchor.constraint(equalTo: foodTypesBackground.rightAnchor, constant: -15.0).isActive = true
        //
        self.foodTypesEditButton.translatesAutoresizingMaskIntoConstraints = false
        //    [foodTypesBackground addSubview:self.foodTypeEditButton];
        foodTypesBackground.addSubview(self.foodTypesEditButton)
        //    self.foodTypeEditButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        self.foodTypesEditButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        //    [self.foodTypeEditButton setTitle:@"Edit" forState:UIControlStateNormal];
        self.foodTypesEditButton.setTitle("Edit", for: .normal)
        //    self.foodTypeEditButton.titleLabel.textColor = UIColor.systemBlueColor;
        self.foodTypesEditButton.titleLabel?.textColor = .systemBlue
        //    [self.foodTypeEditButton.bottomAnchor constraintEqualToAnchor:foodTypesTitleLabel.bottomAnchor].active = YES;
        self.foodTypesEditButton.bottomAnchor.constraint(equalTo: foodTypesTitleLabel.bottomAnchor).isActive = true
        //    [self.foodTypeEditButton.rightAnchor constraintEqualToAnchor:foodTypesBackground.rightAnchor constant:-15.0].active = YES;
        self.foodTypesEditButton.rightAnchor.constraint(equalTo: foodTypesBackground.rightAnchor, constant: -15.0).isActive = true
        //    [self.foodTypeEditButton addTarget:self action:@selector(toggleFoodTypeEditing) forControlEvents:UIControlEventTouchUpInside];
        self.foodTypesEditButton.addTarget(self, action: #selector(toggleFoodTypeEditing), for: .touchUpInside)
        //
        //    self.foodTypeTableView.translatesAutoresizingMaskIntoConstraints = NO;
        self.foodTypeTableView.translatesAutoresizingMaskIntoConstraints = false
        //    self.foodTypeTableView.dataSource = self;
        self.foodTypeTableView.dataSource = self
        //    self.foodTypeTableView.scrollEnabled = NO;
        self.foodTypeTableView.isScrollEnabled = false
        //    self.foodTypeTableView.backgroundColor = UIColor.clearColor;
        self.foodTypeTableView.backgroundColor = .clear
        //    [self.foodTypeTableView registerClass:MealSettingsCell.class forCellReuseIdentifier:@"SettingsCell"];
        self.foodTypeTableView.register(MealSettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        //    [foodTypesBackground addSubview:self.foodTypeTableView];
        foodTypesBackground.addSubview(self.foodTypeTableView)
        //    [self.foodTypeTableView.topAnchor constraintEqualToAnchor:foodTypesTitleLabel.bottomAnchor constant:15.0].active = YES;
        self.foodTypeTableView.topAnchor.constraint(equalTo: foodTypesTitleLabel.bottomAnchor, constant: 15.0).isActive = true
        //    [self.foodTypeTableView.leftAnchor constraintEqualToAnchor:foodTypesBackground.leftAnchor constant:15.0].active = YES;
        self.foodTypeTableView.leftAnchor.constraint(equalTo: foodTypesBackground.leftAnchor, constant: 15.0).isActive = true
        //    [self.foodTypeTableView.rightAnchor constraintEqualToAnchor:foodTypesBackground.rightAnchor constant:-15.0].active = YES;
        self.foodTypeTableView.rightAnchor.constraint(equalTo: foodTypesBackground.rightAnchor, constant: -15.0).isActive = true
        //
        //    self.foodTypeTableView.rowHeight = 50;
        self.foodTypeTableView.rowHeight = 50
        //
        //    UIButton *addPropertyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        let addPropertyButton = UIButton(type: .system)
        addPropertyButton.setImage(UIImage.init(systemName: "plus.circle.fill"), for: .normal)
        //    addPropertyButton.translatesAutoresizingMaskIntoConstraints = NO;
        addPropertyButton.translatesAutoresizingMaskIntoConstraints = false
        //    [foodTypesBackground addSubview:addPropertyButton];
        foodTypesBackground.addSubview(addPropertyButton)
        //    [addPropertyButton.heightAnchor constraintEqualToAnchor:addPropertyButton.widthAnchor].active = YES;
        addPropertyButton.heightAnchor.constraint(equalTo: addPropertyButton.widthAnchor).isActive = true
        //    [addPropertyButton.heightAnchor constraintEqualToConstant:20.0].active = YES;
        addPropertyButton.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        //    [addPropertyButton.rightAnchor constraintEqualToAnchor:foodTypesBackground.rightAnchor constant:-15.0].active = YES;
        addPropertyButton.rightAnchor.constraint(equalTo: foodTypesBackground.rightAnchor, constant: -15.0).isActive = true
        //    [addPropertyButton.topAnchor constraintEqualToAnchor:self.foodTypeTableView.bottomAnchor constant:15.0].active = YES;
        addPropertyButton.topAnchor.constraint(equalTo: self.foodTypeTableView.bottomAnchor, constant: 15.0).isActive = true
        //    [addPropertyButton.bottomAnchor constraintEqualToAnchor:foodTypesBackground.bottomAnchor constant:-15.0].active = YES;
        addPropertyButton.bottomAnchor.constraint(equalTo: foodTypesBackground.bottomAnchor, constant: -15.0).isActive = true
        //    [addPropertyButton addTarget:self action:@selector(presentAddFoodTypeVC) forControlEvents:UIControlEventTouchUpInside];
        addPropertyButton.addTarget(self, action: #selector(presentAddFoodTypeVC), for: .touchUpInside)
    }
    
    @IBAction func toggleFoodTypeEditing() {
        let isEditing = self.foodTypeTableView.isEditing
        self.foodTypeTableView.setEditing(!isEditing, animated: true)
        self.foodTypesEditButton.setTitle(isEditing ? "Done" : "Edit", for: .normal)
    }
    
    @IBAction func presentAddFoodTypeVC() {
        //    AddFoodTypeVC *addFoodTypeVC = [AddFoodTypeVC new];
        //addFoodTypeVC.settingsVC = self;
        let addFoodTypeVC = AddFoodTypeVC()
        addFoodTypeVC.settingsVC = self
        //TODO: animated or no?
        //[self presentViewController:addFoodTypeVC animated:NO completion:nil];
        self.present(addFoodTypeVC, animated: true, completion: nil)
    }
    
    func label(with text:String, fontSize:CGFloat) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }
    
    func addFoodType(with name:String, color:UIColor) {
//        FoodType *newFoodType = [NSEntityDescription insertNewObjectForEntityForName:@"FoodType"
//                                                              inManagedObjectContext:self.appDelegate.persistentContainer.viewContext];
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let newFoodType = NSEntityDescription.insertNewObject(forEntityName: "FoodType",
                                                                    into: appDelegate.persistentContainer.viewContext) as? FoodType else {
            return
        }
//        newFoodType.name = name;
        newFoodType.name = name
//        newFoodType.color = [NSKeyedArchiver archivedDataWithRootObject:color
//                                                  requiringSecureCoding:NO
//                                                                  error:nil];
        do {
            newFoodType.color = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        } catch {
            NSLog("failed to unarchive FoodType color in SettingsViewController")
        }
//        newFoodType.index = [NSUserDefaults.standardUserDefaults integerForKey:@"nextFoodTypeIndex"];
        newFoodType.index = Int16(UserDefaults.standard.integer(forKey: "nextFoodTypeIndex"))
//
//        [self.appDelegate saveContext];
        appDelegate.saveContext()
//        [self.foodTypeTableView reloadData];
        self.foodTypeTableView.reloadData()
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"FoodTypesUpdated" object:nil];
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FoodTypesUpdated"), object: nil)
    }
    
    //MARK: - TableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return 0 }
        return appDelegate.fetchFoodTypes()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as? MealSettingsCell else {
            fatalError()
        }
        cell.foodType = appDelegate.fetchFoodTypes()?[indexPath.row]
        cell.backgroundColor = .clear
        return cell
    }
}
