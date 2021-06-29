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
    
    
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
