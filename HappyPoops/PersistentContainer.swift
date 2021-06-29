//
//  PersistentContainer.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 6/29/21.
//

import Foundation
import CoreData

class PersistentContainer: NSPersistentContainer {
    //TODO: Add common functions like addMeal etc.
    
    //MARK: - Core Data stack
    @objc lazy var persistentContainer: PersistentContainer = {
        let container = PersistentContainer(name: "HappyPoops")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()


    func fetchEvents() -> [Event]? {
        let eventSortDescriptor = NSSortDescriptor.init(key: "date", ascending: true)
        return self.fetchArray(of: "Event", with: eventSortDescriptor) as? [Event]
    }
    
    func fetchFoodTypes() -> [FoodType]? {
        let foodSortDescriptor = NSSortDescriptor.init(key: "index", ascending: true)
        return self.fetchArray(of: "FoodType", with: foodSortDescriptor) as? [FoodType]
    }
    
    func deleteFoodType(at index:Int) {
        if let foodTypeToDelete = self.fetchFoodTypes()?[index] {
            self.persistentContainer.viewContext.delete(foodTypeToDelete)
            self.persistentContainer.saveContext()
            
        }
    }
    
    //MARK: - Core Data Saving support
    func fetchArray(of type:String, with sortDescriptor:NSSortDescriptor) -> [Any] {
        let managedObjectContext = self.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: type, in: managedObjectContext)
        let request = NSFetchRequest<NSFetchRequestResult>.init()
        
        request.entity = entity
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try managedObjectContext.fetch(request)
        } catch {
            NSLog("Error fetching \(type) from core data!")
            fatalError()
        }
    }

    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
    
    func addMeal(with foodTypes:[String:Bool], date:Date) {
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
    
    func addPoop(with rating:Int, date:Date) {
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
        let event = NSEntityDescription.insertNewObject(forEntityName: "Event", into: self.viewContext) as! Event
        event.date = date
        return event
    }

    fileprivate func add(event:Event) {
        self.saveContext()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EventsUpdated"), object: nil)
    }
}
