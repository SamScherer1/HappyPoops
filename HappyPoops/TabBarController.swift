//
//  TabBarController.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 6/28/21.
//

import Foundation
import CoreData
import UIKit


class TabBarController : UITabBarController {
    
    var container: PersistentContainer!
    
    var trackVC = TrackViewController()
    var trackNavigationVC : UINavigationController?
    
    var analyzeVC = AnalyzeViewController()
    var graphNavigationVC : UINavigationController?
    
    var settingsVC = SettingsViewController()
    var settingsNavigationVC : UINavigationController?
    
    convenience init(container: PersistentContainer) {
        self.init()
        self.container = container
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.trackNavigationVC = UINavigationController(rootViewController: trackVC)
        
        self.tabBar.barStyle = .black
        
        // Setup Track View Controller:
        self.trackVC.navigationItem.title = "Track"
        let editButton = UIBarButtonItem(title: " Edit ",
                                         style: .plain,
                                         target: self.trackVC,
                                         action: #selector(trackVC.toggleEditTasks))
        self.trackVC.editButton = editButton
        self.trackVC.navigationItem.leftBarButtonItem = editButton
        
        let addImage = UIImage(systemName: "plus")
        let addEventButton = UIBarButtonItem(image: addImage,
                                             style: .plain,
                                             target: self,
                                             action: #selector(showAddEventVC))

        self.trackVC.navigationItem.rightBarButtonItem = addEventButton

        self.trackNavigationVC = UINavigationController(rootViewController: self.trackVC)
        let trackItem = UITabBarItem(title: "Track", image: UIImage(systemName: "text.badge.checkmark"), tag: 0)

        self.trackNavigationVC?.tabBarItem = trackItem
        self.trackNavigationVC?.navigationBar.barStyle = .black
        
        // Setup Analyze View Controller:
        self.analyzeVC.navigationItem.title = "Analyze"
        let analyzeIcon = UIImage(named: "AnalyzeIcon")
        let thumbnailSize = CGSize(width: 30, height: 30)
        UIGraphicsBeginImageContext(thumbnailSize)
        analyzeIcon?.draw(in: CGRect(x: 0, y: 0, width: thumbnailSize.width, height: thumbnailSize.height))
        let scaledAnalyzeIcon = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()

        let analyzeItem = UITabBarItem(title: "Analyze", image: scaledAnalyzeIcon, tag: 1)
        self.graphNavigationVC = UINavigationController(rootViewController: self.analyzeVC)
        self.graphNavigationVC?.navigationBar.barStyle = .black
        self.graphNavigationVC?.tabBarItem = analyzeItem

        // Setup Settings View Controller:
        self.settingsVC.navigationItem.title = "Settings"
        let settingsIcon = UIImage(systemName: "gear")
        let settingsItem = UITabBarItem(title: "Settings", image: settingsIcon, tag: 2)
        
        self.settingsNavigationVC = UINavigationController(rootViewController: self.settingsVC)
        self.settingsNavigationVC?.tabBarItem = settingsItem
        self.settingsNavigationVC?.navigationBar.barStyle = .black
        
        // Set tab bar view controllers:
        self.viewControllers = [self.trackNavigationVC!, self.graphNavigationVC!, self.settingsNavigationVC!]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard container != nil else {
            fatalError("This view needs a persistent container.")
        }
        self.trackVC.container = container
        self.analyzeVC.container = container
        self.settingsVC.container = container
    }
    
    @IBAction func showAddEventVC() {
        let addEventVC = AddEventViewController()
        addEventVC.container = self.container
        addEventVC.navigationItem.title = "Add Event"
        addEventVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                                       style: .plain,
                                                                       target: addEventVC,
                                                                       action: #selector(addEventVC.doneConfiguringEvent))
        self.trackNavigationVC?.pushViewController(addEventVC, animated: true)
    }
}
