//
//  TrackViewController.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 6/24/21.
//

import Foundation
import CoreData

class TrackViewController: UITableViewController, UITextFieldDelegate {
    
    @objc var editButton : UIBarButtonItem! //TODO: pass in on creation?
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
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.fetchEvents()?.count ?? 0
        }
        return 0
    }
    
    //TODO: a lot of this method is pretty hacky... lots of force unwrapping, casting, use of NSDictionary...
    // Definitely create a coredata stack and revisit all usages of coredata...
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        guard let event = appDelegate.fetchEvents()?[indexPath.row] else { fatalError() }
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
            //mealCell.mealDictionary = qualitiesDictionary as? [String : Bool]
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
    
    @objc @IBAction func editTasks() {
        print("TODO")
    }

    @objc func addMeal(with foodTypes:[String:Bool], date:Date) {
        let mealEvent = createEvent(with: date)
        mealEvent.isMeal = true
        
        do {
            let archivedQualities = try NSKeyedArchiver.archivedData(withRootObject: foodTypes,
                                                                     requiringSecureCoding: false)
            mealEvent.qualitiesDictionary = archivedQualities
        } catch {
            fatalError()
        }
        self.add(event: mealEvent)
    }
    
    @objc func addPoop(with rating:Int, date:Date) {
        let poopEvent = createEvent(with: date)
        poopEvent.isMeal = false
        
        do {
            let archivedQualities = try NSKeyedArchiver.archivedData(withRootObject: ["rating": rating],
                                                                     requiringSecureCoding: false)
            poopEvent.qualitiesDictionary = archivedQualities
        } catch {
            fatalError()
        }
        self.add(event: poopEvent)
    }
    
    func createEvent(with date:Date) -> Event {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let event = NSEntityDescription.insertNewObject(forEntityName: "Event", into: managedObjectContext) as! Event
        event.date = date
        return event
    }

    func add(event:Event) {
        self.dismiss(animated: true, completion: nil)//TODO: necessary?
        self.tableView.reloadData()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        appDelegate.saveContext()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EventsUpdated"), object: nil)
    }
}
