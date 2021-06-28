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
        foodTypesBackground.backgroundColor = .gray//TODO: use category
        foodTypesBackground.layer.cornerRadius = 15.0
        self.view.addSubview(foodTypesBackground)
        foodTypesBackground.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15.0).isActive = true
        foodTypesBackground.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5.0).isActive = true
        foodTypesBackground.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15.0).isActive = true
        
        let foodTypesTitleLabel = self.label(with: "Food Types", fontSize: 24.0)
        foodTypesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        foodTypesBackground.addSubview(foodTypesTitleLabel)
        foodTypesTitleLabel.topAnchor.constraint(equalTo: foodTypesBackground.topAnchor, constant: 15.0).isActive = true
        foodTypesTitleLabel.leftAnchor.constraint(equalTo: foodTypesBackground.leftAnchor, constant: 15.0).isActive  = true
        foodTypesTitleLabel.rightAnchor.constraint(equalTo: foodTypesBackground.rightAnchor, constant: -15.0).isActive = true
        //
        self.foodTypesEditButton.translatesAutoresizingMaskIntoConstraints = false
        foodTypesBackground.addSubview(self.foodTypesEditButton)
        self.foodTypesEditButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        self.foodTypesEditButton.setTitle("Edit", for: .normal)
        self.foodTypesEditButton.titleLabel?.textColor = .systemBlue
        self.foodTypesEditButton.bottomAnchor.constraint(equalTo: foodTypesTitleLabel.bottomAnchor).isActive = true
        self.foodTypesEditButton.rightAnchor.constraint(equalTo: foodTypesBackground.rightAnchor, constant: -15.0).isActive = true
        self.foodTypesEditButton.addTarget(self, action: #selector(toggleFoodTypeEditing), for: .touchUpInside)
        
        self.foodTypeTableView.translatesAutoresizingMaskIntoConstraints = false
        self.foodTypeTableView.dataSource = self
        self.foodTypeTableView.isScrollEnabled = false
        self.foodTypeTableView.backgroundColor = .clear
        self.foodTypeTableView.register(MealSettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        foodTypesBackground.addSubview(self.foodTypeTableView)
        self.foodTypeTableView.topAnchor.constraint(equalTo: foodTypesTitleLabel.bottomAnchor, constant: 15.0).isActive = true
        self.foodTypeTableView.leftAnchor.constraint(equalTo: foodTypesBackground.leftAnchor, constant: 15.0).isActive = true
        self.foodTypeTableView.rightAnchor.constraint(equalTo: foodTypesBackground.rightAnchor, constant: -15.0).isActive = true
        
        self.foodTypeTableView.rowHeight = 50
        
        let addPropertyButton = UIButton(type: .system)
        addPropertyButton.setImage(UIImage.init(systemName: "plus.circle.fill"), for: .normal)
        addPropertyButton.translatesAutoresizingMaskIntoConstraints = false
        foodTypesBackground.addSubview(addPropertyButton)
        addPropertyButton.heightAnchor.constraint(equalTo: addPropertyButton.widthAnchor).isActive = true
        addPropertyButton.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        addPropertyButton.rightAnchor.constraint(equalTo: foodTypesBackground.rightAnchor, constant: -15.0).isActive = true
        addPropertyButton.topAnchor.constraint(equalTo: self.foodTypeTableView.bottomAnchor, constant: 15.0).isActive = true
        addPropertyButton.bottomAnchor.constraint(equalTo: foodTypesBackground.bottomAnchor, constant: -15.0).isActive = true
        addPropertyButton.addTarget(self, action: #selector(presentAddFoodTypeVC), for: .touchUpInside)
    }
    
    @IBAction func toggleFoodTypeEditing() {
        let isEditing = self.foodTypeTableView.isEditing
        self.foodTypeTableView.setEditing(!isEditing, animated: true)
        self.foodTypesEditButton.setTitle(isEditing ? "Done" : "Edit", for: .normal)
    }
    
    @IBAction func presentAddFoodTypeVC() {
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let newFoodType = NSEntityDescription.insertNewObject(forEntityName: "FoodType",
                                                                    into: appDelegate.persistentContainer.viewContext) as? FoodType else {
            return
        }
        newFoodType.name = name

        do {
            newFoodType.color = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        } catch {
            NSLog("failed to unarchive FoodType color in SettingsViewController")
        }

        newFoodType.index = Int16(UserDefaults.standard.integer(forKey: "nextFoodTypeIndex"))
        appDelegate.saveContext()
        self.foodTypeTableView.reloadData()

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
        cell.update(with: (appDelegate.fetchFoodTypes()?[indexPath.row])!)//TODO: reconsider ! unwrap
        
        return cell
    }
}
