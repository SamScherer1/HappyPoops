//
//  AppDelegate.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 6/23/21.
//  Copyright © 2021 SamuelScherer. All rights reserved.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var tabBarController: TabBarController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Give Persistent Container to TabBarController which then passes it into the other VC's when loaded
        if let rootVC = window?.rootViewController as? TabBarController {
            rootVC.container = persistentContainer
        }
        
        // Set initial food types
        if !UserDefaults.standard.bool(forKey: "launchedBefore") {
            UserDefaults.standard.set(3, forKey: "nextFoodTypeIndex")//TODO: this is a kinda hacky way to keep food types in order...
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
            let foodTypeLactose = NSEntityDescription.insertNewObject(forEntityName: "FoodType",
                                                                      into: self.persistentContainer.viewContext) as! FoodType
            let foodTypeGluten = NSEntityDescription.insertNewObject(forEntityName: "FoodType",
                                                                     into: self.persistentContainer.viewContext) as! FoodType
            let foodTypeNuts = NSEntityDescription.insertNewObject(forEntityName: "FoodType",
                                                                   into: self.persistentContainer.viewContext) as! FoodType
            
            do {
                foodTypeLactose.color = try NSKeyedArchiver.archivedData(withRootObject: UIColor.white,
                                                                   requiringSecureCoding: false)

                foodTypeGluten.color = try NSKeyedArchiver.archivedData(withRootObject: UIColor.yellow,
                                                                  requiringSecureCoding: false)

                foodTypeNuts.color = try NSKeyedArchiver.archivedData(withRootObject: UIColor.brown,
                                                                requiringSecureCoding: false)
            } catch {
                NSLog("Failed to archive initial FoodType colors")
            }
            
            foodTypeLactose.name = "Lactose"
            foodTypeGluten.name = "Gluten"
            foodTypeNuts.name = "Nuts"
            
            foodTypeLactose.index = 1
            foodTypeGluten.index = 2
            foodTypeNuts.index = 3
            self.persistentContainer.saveContext()
        } else {
            NSLog("Launched before")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
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

    func applicationWillTerminate(_ application: UIApplication) {
        self.persistentContainer.saveContext()
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
}
