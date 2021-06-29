//
//  TabBarController.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 6/28/21.
//

import Foundation
import UIKit


class TabBarController : UITabBarController {
    var trackVC = TrackViewController()
    var trackNavigationVC : UINavigationController?
    
    var analyzeVC = AnalyzeViewController()
    var graphNavigationVC : UINavigationController?
    
    var settingsVC = SettingsViewController()
    var settingsNavigationVC : UINavigationController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trackNavigationVC = UINavigationController(rootViewController: trackVC)
        
        
        //[self.tabBar setBarStyle:UIBarStyleBlack];
        self.tabBar.barStyle = .black
        
        // Setup Track View Controller:
        //    self.trackVC.navigationItem.title = @"Track";
        self.trackVC.navigationItem.title = "Track"
        //
        //    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@" Edit "
        //                                                       style:UIBarButtonItemStylePlain
        //                                                      target:self.trackVC
        //                                                      action:@selector(editTasks)];
        let editButton = UIBarButtonItem(title: " Edit ",
                                         style: .plain,
                                         target: self.trackVC,
                                         action: #selector(trackVC.editTasks))
        //    self.trackVC.editButton = editButton;
        self.trackVC.editButton = editButton
        //
        //    self.trackVC.navigationItem.leftBarButtonItem = editButton;
        self.trackVC.navigationItem.leftBarButtonItem = editButton
        //
        //    UIImage *addImage = [UIImage systemImageNamed:@"plus"];
        let addImage = UIImage(systemName: "plus")
        //
        //    UIBarButtonItem *addEventButton = [[UIBarButtonItem alloc] initWithImage:addImage
        //                                                         style:UIBarButtonItemStylePlain
        //                                                        target:self
        //                                                        action:@selector(showAddTaskVC)];
        let addEventButton = UIBarButtonItem(image: addImage,
                                             style: .plain,
                                             target: self,
                                             action: #selector(showAddTaskVC))
        //
        //    self.trackVC.navigationItem.rightBarButtonItem = addEventButton;
        self.trackVC.navigationItem.rightBarButtonItem = addEventButton
        //
        //    self.trackNavigationVC = [[UINavigationController alloc] initWithRootViewController:self.trackVC];
        self.trackNavigationVC = UINavigationController(rootViewController: self.trackVC)
        //
        //    UITabBarItem *trackItem = [[UITabBarItem alloc] initWithTitle:@"Track"
        //                                                                image:[UIImage systemImageNamed:@"text.badge.checkmark"]
        //                                                                  tag:0];
        let trackItem = UITabBarItem(title: "Track", image: UIImage(systemName: "text.badge.checkmark"), tag: 0)
        //
        //    self.trackNavigationVC.tabBarItem = trackItem;
        self.trackNavigationVC?.tabBarItem = trackItem
        //    self.trackNavigationVC.navigationBar.barStyle = UIBarStyleBlack;
        self.trackNavigationVC?.navigationBar.barStyle = .black
        
        // Setup Analyze View Controller:
        //    self.analyzeVC.navigationItem.title = @"Analyze";
        self.analyzeVC.navigationItem.title = "Analyze"
        //    UIImage *analyzeIcon = [UIImage imageNamed:@"AnalyzeIcon"];
        let analyzeIcon = UIImage(named: "AnalyzeIcon")
        //    CGSize thumbnailSize = CGSizeMake(30, 30);
        let thumbnailSize = CGSize(width: 30, height: 30)
        //    UIGraphicsBeginImageContextWithOptions(thumbnailSize, NO, 0.0);
        UIGraphicsBeginImageContext(thumbnailSize)
        //    [analyzeIcon drawInRect:CGRectMake(0, 0, thumbnailSize.width, thumbnailSize.height)];
        analyzeIcon?.draw(in: CGRect(x: 0, y: 0, width: thumbnailSize.width, height: thumbnailSize.height))
        //    UIImage *scaledAnalyzeIcon = UIGraphicsGetImageFromCurrentImageContext();
        let scaledAnalyzeIcon = UIGraphicsGetImageFromCurrentImageContext()
        
        //    UIGraphicsEndImageContext();
        UIGraphicsEndImageContext()
        //
        //    UITabBarItem *analyzeItem = [[UITabBarItem alloc] initWithTitle:@"Analyze"
        //                                                             image:scaledAnalyzeIcon
        //                                                               tag:1];
        let analyzeItem = UITabBarItem(title: "Analyze", image: scaledAnalyzeIcon, tag: 1)
        //    self.graphNavigationVC = [[UINavigationController alloc] initWithRootViewController:self.analyzeVC];
        self.graphNavigationVC = UINavigationController(rootViewController: self.analyzeVC)
        //    self.graphNavigationVC.navigationBar.barStyle = UIBarStyleBlack;
        self.graphNavigationVC?.navigationBar.barStyle = .black
        //    self.graphNavigationVC.tabBarItem = analyzeItem;
        self.graphNavigationVC?.tabBarItem = analyzeItem
        
        //Previously Commented...
        //    UIBarButtonItem *editGraphButton = [[UIBarButtonItem alloc] initWithTitle:@" Edit "
        //                                                                        style:UIBarButtonItemStylePlain
        //                                                                       target:self.analyzeVC
        //                                                                       action:@selector(editGraphs)];
        //
        //    self.analyzeVC.navigationItem.leftBarButtonItem = editGraphButton;
        ///-------
        //
        // Setup Settings View Controller:
        //    self.settingsVC.navigationItem.title = @"Settings";
        self.settingsVC.navigationItem.title = "Settings"
        //    UIImage *settingsIcon = [UIImage systemImageNamed:@"gear"];]
        let settingsIcon = UIImage(systemName: "gear")
        //    UITabBarItem *settingsItem = [[UITabBarItem alloc] initWithTitle:@"Settings"
        //                                                               image:settingsIcon
        //                                                                 tag:2];
        let settingsItem = UITabBarItem(title: "Settings", image: settingsIcon, tag: 2)
        //
        //    self.settingsNavigationVC = [[UINavigationController alloc] initWithRootViewController:self.settingsVC];
        self.settingsNavigationVC = UINavigationController(rootViewController: self.settingsVC)
        //    self.settingsNavigationVC.tabBarItem = settingsItem;
        self.settingsNavigationVC?.tabBarItem = settingsItem
        //    self.settingsNavigationVC.navigationBar.barStyle = UIBarStyleBlack;
        self.settingsNavigationVC?.navigationBar.barStyle = .black
        
        //TODO: are navigation controllers unnecessary now? Looks like it's asking for UIViewControllers...
        // Set tab bar view controllers:
        //    self.viewControllers = @[self.trackNavigationVC, self.graphNavigationVC, self.settingsNavigationVC];
        self.viewControllers = [self.trackNavigationVC!, self.graphNavigationVC!, self.settingsNavigationVC!]
    }
    
    @IBAction func showAddTaskVC() {
        let addEventVC = AddEventViewController()
        addEventVC.trackViewController = self.trackVC
        addEventVC.navigationItem.title = "Add Event"
        addEventVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                                       style: .plain,
                                                                       target: addEventVC,
                                                                       action: #selector(addEventVC.doneConfiguringEvent))
        self.trackNavigationVC?.pushViewController(addEventVC, animated: true)//TODO: animated?
    }
}
