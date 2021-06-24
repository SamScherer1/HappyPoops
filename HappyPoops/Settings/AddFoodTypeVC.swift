//
//  SAMAddFoodTypeVC.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 3/29/21.
//  Copyright © 2021 SamuelScherer. All rights reserved.
//

import Foundation
import UIKit

@objc class AddFoodTypeVC : UIViewController {
    var nameTextView : UITextView
    var colorWell : UIColorWell
    @objc public var settingsVC : SAMSettingsViewController?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        nameTextView = UITextView()
        colorWell = UIColorWell()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        let titleLabel = UILabel()
        self.view.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 24.0)
        titleLabel.text = "Add Food Type"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.white
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant:15.0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant:15.0).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15.0).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15.0).isActive = true
        nameLabel.text = "Name"
        nameLabel.textColor = UIColor.white
        
        self.nameTextView = UITextView()

        self.nameTextView.textContainer.maximumNumberOfLines = 1
        self.nameTextView.textContainer.lineBreakMode = .byClipping

        self.nameTextView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.nameTextView)
        self.nameTextView.layer.cornerRadius = 5.0;
        self.nameTextView.backgroundColor = UIColor.lightGray
        self.nameTextView.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 15.0).isActive = true
        self.nameTextView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        self.nameTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15.0).isActive = true
        self.nameTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0).isActive = true
        
        let colorLabel = UILabel()
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(colorLabel)
        colorLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15.0).isActive = true
        colorLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 25.0).isActive = true
        colorLabel.text = "Color"
        colorLabel.textColor = UIColor.white
        
        self.colorWell = UIColorWell()
        self.colorWell.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.colorWell)
        self.colorWell.leftAnchor.constraint(equalTo: colorLabel.rightAnchor, constant: 15.0).isActive = true
        self.colorWell.centerYAnchor.constraint(equalTo: colorLabel.centerYAnchor).isActive = true
        self.colorWell.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        let okButton = UIButton.init(type: .system)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(okButton)
        okButton.titleLabel?.textColor = UIColor.systemBlue
        okButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        okButton.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 10.0).isActive = true
        okButton.setTitle("Add Food Type", for: UIControl.State.normal)
        okButton.addTarget(self, action: #selector(addFoodType), for:.touchUpInside)

        let cancelButton = UIButton.init(type: .system)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cancelButton)
        cancelButton.titleLabel?.textColor = UIColor.systemRed
        cancelButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        cancelButton.topAnchor.constraint(equalTo: okButton.bottomAnchor, constant: 10.0).isActive = true
        cancelButton.setTitle("Cancel", for: UIControl.State.normal)
        cancelButton.addTarget(self, action: #selector(cancelAddFoodType), for:.touchUpInside)
    }
    
    @objc func addFoodType() {
        if let settingsVC = self.settingsVC {
            settingsVC.addFoodType(withName: self.nameTextView.text, andColor: self.colorWell.selectedColor ?? UIColor.black)
        }
        dismiss(animated: false, completion: nil)
    }
    
    @objc func cancelAddFoodType() {
        dismiss(animated: false, completion: nil)
    }
    
}
