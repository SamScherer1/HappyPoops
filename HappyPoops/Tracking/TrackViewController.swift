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
        
        //TODO: Instead of highlighting selected cell, show a line with the event's time
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
    
    @IBAction func reloadTableView() {
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
        cell?.overrideUserInterfaceStyle = .dark
        return cell!
    }
    
    @IBAction func toggleEditTasks() {
        let isEditing = self.tableView.isEditing
        self.editButton.title = isEditing ? " Edit " : " Done "
        self.tableView.setEditing(!isEditing, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if self.tableView.isEditing {
            return .delete
        }
        return .none
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let eventToDelete = self.container.fetchEvents()?[indexPath.row] else { return }
            self.container.delete(event: eventToDelete)
            //TODO: delete explicitly for nice animation...
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let eventToMove = self.container.fetchEvents()?[sourceIndexPath.row] else { fatalError() }
        
        //Present Alert with datePicker, callback to set event time
        
    }
    
    //    NSMutableArray *eventArray = [NSMutableArray arrayWithArray:[self.appDelegate fetchEvents]];
    //    Event *fromEvent = eventArray[fromIndexPath.row];
    //    [eventArray removeObjectAtIndex:fromIndexPath.row];
    //    [eventArray insertObject:fromEvent atIndex:toIndexPath.row];
    //    [self.appDelegate saveContext];
    //}
    
    //- (void)mockValueDataForTask:(Event *)event {
    //    NSMutableDictionary *mockValueDictionary = [self mockedValueDictionary];
    //    NSMutableArray *mockValueArray = [mockValueDictionary objectForKey:@"userInputNumbers"];
    //    NSData *mockUserInput = [NSKeyedArchiver archivedDataWithRootObject:mockValueArray requiringSecureCoding:YES error:nil];
    //    NSData *mockTimeData = [NSKeyedArchiver archivedDataWithRootObject:[mockValueDictionary objectForKey:@"completionTimes"] requiringSecureCoding:YES error:nil];
    //    [self.editingNumberTask setValue:mockTimeData forKey:@"completionTimes"];
    //    [self.editingNumberTask setValue:mockUserInput forKey:@"userInputNumbers"];
    //}

//    - (NSMutableDictionary *)mockedValueDictionary {
//        //Mock test data:
//        NSMutableArray *taskCompletionTimes = [NSMutableArray new];
//        NSMutableArray *userInputTimes = [NSMutableArray new];
//        //NSTimeInterval threeDays = -240800;
//        NSTimeInterval dayAndABit = -89400;
//        //NSTimeInterval day = -86400;
//
//        for (int i = 40; i >= 0; i--) {
//            NSDate *date = [[NSDate date] dateByAddingTimeInterval:dayAndABit * i];
//            [taskCompletionTimes addObject:date];
//            [userInputTimes addObject:[NSNumber numberWithInt:i]];
//        }
//        NSMutableDictionary *mockedValueData = [NSMutableDictionary new];
//        [mockedValueData setValue:taskCompletionTimes forKey:@"completionTimes"];
//        [mockedValueData setValue:userInputTimes forKey:@"userInputNumbers"];
//        return mockedValueData;
//    }


//    - (NSMutableArray *)mockedTimeArray {
//        //Mock test data:
//        NSMutableArray *taskCompletionTimes = [NSMutableArray new];
//        //NSTimeInterval threeDays = -240800;
//        NSTimeInterval dayAndABit = -89400;
//        //NSTimeInterval day = -86400;
//
//        for (int i = 30; i >= 0; i--) {
//            NSDate *date = [[NSDate date] dateByAddingTimeInterval:dayAndABit * i];
//            [taskCompletionTimes addObject:date];
//        }
//        return taskCompletionTimes;

    //    [taskCompletionTimes addObject:date0];
    //    [taskCompletionTimes addObject:date1];
        //[taskCompletionTimes addObject:[NSDate date]];
    //}
}
