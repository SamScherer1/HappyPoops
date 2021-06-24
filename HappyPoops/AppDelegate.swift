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
    var tabBarController: SAMTabBarController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
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
            self.saveContext()
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
    @objc lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HappyPoops")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()


    @objc func fetchEvents() -> [Event] {
        //NSSortDescriptor *eventSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
        //return [self fetchArrayOfType:@"Event" withSortDescriptor:eventSortDescriptor];
        let eventSortDescriptor = NSSortDescriptor.init(key: "date", ascending: true)
        return self.fetchArray(of: "Event", with: eventSortDescriptor) as! [Event] //TODO: reconsider force...
    }
    
    @objc func fetchFoodTypes() -> [FoodType] {
        //    NSSortDescriptor *foodTypeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
        //    return [self fetchArrayOfType:@"FoodType" withSortDescriptor:foodTypeSortDescriptor];
        let foodSortDescriptor = NSSortDescriptor.init(key: "index", ascending: true)
        return self.fetchArray(of: "FoodType", with: foodSortDescriptor) as! [FoodType]//TODO: reconsider force...
    }
    
    @objc func saveContext() {
        let context = self.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // TODO: Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error");
                abort()
            }
        }
    }
    
    @objc func deleteFoodType(at index:Int) {
        print("TODOOOOO")
        //    FoodType *foodTypeToDelete = [[self fetchFoodTypes] objectAtIndex:index];
        //    [self.persistentContainer.viewContext deleteObject:foodTypeToDelete];
        self.saveContext()
    }
    
    //TODO: necessary?
    //- (void)applicationWillEnterForeground:(UIApplication *)application {
    //    if (self.tabBarController != nil) {
    //        [self.tabBarController.trackVC.tableView reloadData];
    //    }
    //}

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    //MARK: - Core Data Saving support
    //
    // Type can be "Event" or "FoodType"
    //- (NSMutableArray *)fetchArrayOfType:(NSString *)type withSortDescriptor:(NSSortDescriptor *)sortDescriptor {
    
    //    NSManagedObjectContext *managedObjectContext = self.persistentContainer.viewContext;
    //
    //    NSEntityDescription *entity = [NSEntityDescription entityForName:type inManagedObjectContext:managedObjectContext];
    //    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //    [request setEntity:entity];
    //
    //    NSArray *sortDescriptorArray = @[sortDescriptor];
    //    [request setSortDescriptors:sortDescriptorArray];
    //
    //    NSMutableArray *fetchResults = [[managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
    //    if (!fetchResults) {
    //        NSLog(@"Failed to load %@s from disk", type);
    //        return nil;
    //    }
    //    return fetchResults;
    //}
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
    
    //+ (NSMutableArray *)fetchArrayForData:(NSData *)archivedArray ofClass:(Class)class {
    //func fetchArray(for data:Data, ofType:AnyClass) -> [Any] {
        //    NSSet *arrayAndDateClasses = [[NSSet alloc] initWithArray:@[NSMutableArray.class, class]];
        //    NSMutableArray *dates = [NSKeyedUnarchiver unarchivedObjectOfClasses:arrayAndDateClasses
        //                                                                fromData:archivedArray
        //                                                                   error:nil];
        //    return dates;
        //return NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: ofType, from: data)
      //  return []
    //}
}
