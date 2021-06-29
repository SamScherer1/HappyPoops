//
//  TrackViewController.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 6/24/21.
//

import Foundation
import UIKit
import CoreData

class TrackViewController: UITableViewController, UITextFieldDelegate {
    
    var container : PersistentContainer!
    var editButton : UIBarButtonItem! //TODO: pass in on creation?
    var singleTapGestureRecognizer: UIGestureRecognizer?
    
    override func loadView() {
        super.loadView()
        
        self.tableView.register(MealCell.self, forCellReuseIdentifier: "MealCell")
        self.tableView.register(PoopCell.self, forCellReuseIdentifier: "PoopCell")
        
        //TODO: needs content offset?
        //        [self.tableView setContentInset:UIEdgeInsetsMake(5,0,0,0)];
        //self.tableView.setContentOffset(??, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 60
        
        self.tableView.backgroundColor = .black
        
        // Add Tap Gesture Recognizer for showing time of completion
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTaps))
        self.tableView.addGestureRecognizer(tapRecognizer)
        self.tableView.setEditing(false, animated: false)//TODO: necessary? test returning to it after leaving it in editing mode...
        self.tableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadTableView),
                                               name: NSNotification.Name(rawValue: "FoodTypesUpdated"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadTableView),
                                               name: NSNotification.Name(rawValue: "EventsUpdated"),
                                               object: nil)

    }
    
    @IBAction func handleTaps() {
        //TODO
    }
    
    @IBAction func reloadTableView() {
        //TODO: perform on main thread?
//        [self.tableView performSelectorOnMainThread:@selector(reloadData)
//                                          withObject:nil
//                                       waitUntilDone:NO];
        self.tableView.reloadData()
    }
    
    //MARK: - UITableViewDataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.container.fetchEvents()?.count ?? 0
    }
    
    //TODO: a lot of this method is pretty hacky... lots of force unwrapping, casting, use of NSDictionary...
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let event = self.container.fetchEvents()?[indexPath.row] else { fatalError() }
        var nullableQualitiesDictionary : NSDictionary?
        do {
            nullableQualitiesDictionary = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSDictionary.self,
                                                                                 from: event.qualitiesDictionary!)
        } catch {
            fatalError()
        }
        guard let qualitiesDictionary = nullableQualitiesDictionary else { fatalError() }
        
        var cell: TrackCell?
        if event.isMeal {
            let mealCell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealCell
            mealCell.container = self.container
            mealCell.updateCircles(with: qualitiesDictionary as! [String: Bool])//TODO: reconsider force unwrap
            cell = mealCell
        } else {
            let poopCell = tableView.dequeueReusableCell(withIdentifier: "PoopCell", for: indexPath) as! PoopCell
            if let poopQuality = qualitiesDictionary["rating"] as? Int {
                poopCell.set(quality:poopQuality)
            }
            cell = poopCell
        }
        return cell!
    }
    
    @IBAction func editTasks() {
        print("TODO")
        self.tableView.setEditing(true, animated: true)
    }
}
