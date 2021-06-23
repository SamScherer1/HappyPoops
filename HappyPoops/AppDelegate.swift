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
    @objc var persistentContainer: NSPersistentContainer!
    var tabBarController: SAMTabBarController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        self.window = UIWindow.init(frame: UIScreen.main.bounds)
//        //self.tabBarController = SAMTabBarController.init()
//        //self.window?.rootViewController = self.tabBarController
//        self.window?.rootViewController = TestViewController()
//        self.window?.makeKeyAndVisible()
//        return true //TODO: remove to add default options...
        
        // Set initial food types
        if UserDefaults.standard.bool(forKey: "launchedBefore") {
        //TODO: setup defaults...
        //    [NSUserDefaults.standardUserDefaults setInteger:3 forKey:@"nextFoodTypeIndex"];
        //    [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"launchedBefore"];
        //
        //    NSData *archivedWhite = [NSKeyedArchiver archivedDataWithRootObject:UIColor.whiteColor
        //                                                  requiringSecureCoding:NO
        //                                                                  error:nil];
        //
        //    NSData *archivedYellow = [NSKeyedArchiver archivedDataWithRootObject:UIColor.yellowColor
        //                                                   requiringSecureCoding:NO
        //                                                                   error:nil];
        //    NSData *archivedBrown = [NSKeyedArchiver archivedDataWithRootObject:UIColor.brownColor
        //                                                   requiringSecureCoding:NO
        //                                                                   error:nil];
        //
        //    FoodType *foodTypeLactose = [NSEntityDescription insertNewObjectForEntityForName:@"FoodType"
        //                                                             inManagedObjectContext:self.persistentContainer.viewContext];
        //    FoodType *foodTypeGluten = [NSEntityDescription insertNewObjectForEntityForName:@"FoodType"
        //                                                             inManagedObjectContext:self.persistentContainer.viewContext];
        //    FoodType *foodTypeNuts = [NSEntityDescription insertNewObjectForEntityForName:@"FoodType"
        //                                                             inManagedObjectContext:self.persistentContainer.viewContext];
        //    foodTypeLactose.color = archivedWhite;
        //    foodTypeGluten.color = archivedYellow;
        //    foodTypeNuts.color = archivedBrown;
        //
        //    foodTypeLactose.name = @"Lactose";
        //    foodTypeGluten.name = @"Gluten";
        //    foodTypeNuts.name = @"Nuts";
        //
        //    foodTypeLactose.index = 1;
        //    foodTypeGluten.index = 2;
        //    foodTypeNuts.index = 3;
        //    [self saveContext];
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
    //
    //@synthesize persistentContainer = _persistentContainer;
    //
    //- (NSPersistentContainer *)persistentContainer {
    //    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    //    @synchronized (self) {
    //        if (_persistentContainer == nil) {
    //            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"HappyPoops"];
    //            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
    //                if (error != nil) {
    //                    // Replace this implementation with code to handle the error appropriately.
    //                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //
    //                    /*
    //                     Typical reasons for an error here include:
    //                     * The parent directory does not exist, cannot be created, or disallows writing.
    //                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
    //                     * The device is out of space.
    //                     * The store could not be migrated to the current model version.
    //                     Check the error message to determine what the actual problem was.
    //                    */
    //                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
    //                    abort();
    //                }
    //            }];
    //        }
    //    }
    //
    //    return _persistentContainer;
    //}


    @objc func fetchEvents() -> [Event] {
        //    NSSortDescriptor *eventSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
        //    return [self fetchArrayOfType:@"Event" withSortDescriptor:eventSortDescriptor];
        return [Event]()//TODO
    }
    
    @objc func fetchFoodTypes() -> [FoodType] {
        //    NSSortDescriptor *foodTypeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
        //    return [self fetchArrayOfType:@"FoodType" withSortDescriptor:foodTypeSortDescriptor];
        return [FoodType]()//TODO
    }
    
    @objc func saveContext() {
        print("TODO!!!")
        //NSManagedObjectContext *context = self.persistentContainer.viewContext;
        //NSError *error = nil;
        //if ([context hasChanges] && ![context save:&error]) {
        //    // Replace this implementation with code to handle the error appropriately.
        //    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        //    abort();
        //}
    }
    
    @objc func deleteFoodType(at index:Int) {
        print("TODOOOOO")
        //    FoodType *foodTypeToDelete = [[self fetchFoodTypes] objectAtIndex:index];
        //    [self.persistentContainer.viewContext deleteObject:foodTypeToDelete];
        //    [self saveContext];
    }
    //- (void)applicationWillEnterForeground:(UIApplication *)application {
    //    if (self.tabBarController != nil) {
    //        [self.tabBarController.trackVC.tableView reloadData];
    //    }
    //}
    //- (void)applicationWillTerminate:(UIApplication *)application {
    //    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //    // Saves changes in the application's managed object context before the application terminates.
    //    [self saveContext];
    //}
    
}
//
//#pragma mark - Core Data Saving support
//
//// Type can be "Task" or "Graph"
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
//
//+ (NSMutableArray *)fetchArrayForData:(NSData *)archivedArray ofClass:(Class)class {
//    NSSet *arrayAndDateClasses = [[NSSet alloc] initWithArray:@[NSMutableArray.class, class]];
//    NSMutableArray *dates = [NSKeyedUnarchiver unarchivedObjectOfClasses:arrayAndDateClasses
//                                                                fromData:archivedArray
//                                                                   error:nil];
//    return dates;
//}
