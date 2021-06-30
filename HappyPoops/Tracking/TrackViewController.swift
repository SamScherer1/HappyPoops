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
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
        
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
        var cell: EventCell?
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

        if let date = event.date {
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            timeFormatter.dateStyle = .none

            cell?.timeLabel.text = timeFormatter.string(from: date)

            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .short

            cell?.dateLabel.text = dateFormatter.string(from: date)
            if indexPath.row == 0 {
                cell?.dateLabelHeightConstraint?.constant = 20.0
                cell?.cellHeightConstraint?.constant = 80.0
            } else {
                if let lastEvent = self.container.fetchEvents()?[indexPath.row - 1], let lastEventDate = lastEvent.date {
                    let cal = Calendar.current
                    if cal.isDate(lastEventDate, inSameDayAs: date) {
                        cell?.dateLabelHeightConstraint?.constant = 0.0
                        cell?.cellHeightConstraint?.constant = 60.0
                    } else {
                        cell?.dateLabelHeightConstraint?.constant = 20.0
                        cell?.cellHeightConstraint?.constant = 80.0
                    }
                }
            }
        }
        cell?.overrideUserInterfaceStyle = .dark
        cell?.selectionStyle = .none

        return cell!
    }
    
    @IBAction func toggleEditTasks() {
        self.hideTimeOnSelectedRow()
        let isEditing = self.tableView.isEditing
        self.editButton.title = isEditing ? " Edit " : " Done "
        self.tableView.setEditing(!isEditing, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.hideTimeOnSelectedRow()
    }
    
    func hideTimeOnSelectedRow() {
        if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
            if let cellToHideTime = self.tableView.cellForRow(at: selectedIndexPath) as? EventCell {
                cellToHideTime.timeLabel.isHidden = true
            }
        }
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
        
        //TODO: Present Alert with datePicker, callback to set event time
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellToSelect = tableView.cellForRow(at: indexPath) as? EventCell else { return }
        cellToSelect.timeLabel.isHidden = false
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cellToDeselect = tableView.cellForRow(at: indexPath) as? EventCell else { return }
        cellToDeselect.timeLabel.isHidden = true
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
