//
//  TrackViewController.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 6/24/21.
//

import Foundation

//TODO: convert to UITableViewController?
class TrackViewController: UITableViewController, UITextFieldDelegate {
    
    //TODO: appDelegate property unnecessary right?
//    @property (strong, nonatomic) AppDelegate *appDelegate;
//    @property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
    
//    @property (weak, nonatomic) UIBarButtonItem *editButton;
    var editButton : UIButton! //TODO: pass in on creation?
    //TODO: Unnecessary?
//    @property (strong, nonatomic) MyDataController *dataController;
//    @property (strong, nonatomic) UITableView *tableView;
    //var tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
    
//    @property (strong, nonatomic) UIGestureRecognizer *singleTapGestureRecognizer;
    var singleTapGestureRecognizer: UIGestureRecognizer?
//    @property (strong, nonatomic) UIGestureRecognizer *doubleTapGestureRecognizer;
    var doubleTapGestureRecognizer: UIGestureRecognizer?// unnecessary?
//    @property (strong, nonatomic) UIGestureRecognizer *tripleTapGestureRecognizer;
    var tripleTapGestureRecognizer: UIGestureRecognizer?
    
    override func loadView() {
        super.loadView()
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.tableView)
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.tableView.register(MealCell.self, forCellReuseIdentifier: "MealCell")
        self.tableView.register(SAMPoopCell.self, forCellReuseIdentifier: "PoopCell")
        
        //TODO: needs content offset?
        //        [self.tableView setContentInset:UIEdgeInsetsMake(5,0,0,0)];
        //self.tableView.setContentOffset(??, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //    self.tableView.rowHeight = 60;
        self.tableView.rowHeight = 60
    //
            //TODO: just use these instead of properties (get appdelegate each time...)
    //    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
    //    self.managedObjectContext = self.appDelegate.persistentContainer.viewContext;
    //
        //TODO: need to set delegate or included in UITableViewController?
    //    self.tableView.delegate = self;
        //TODO: Should allow selection right?
    //    self.tableView.allowsSelection = NO;
        
        self.tableView.backgroundColor = .black
    //
        // Add Tap Gesture Recognizer for showing time of completion
    //        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapsFromGestureRecognizer:)];
       //tapRecognizer.numberOfTapsRequired = taps;
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTaps))
       // [self.tableView addGestureRecognizer:tapRecognizer];
        self.tableView.addGestureRecognizer(tapRecognizer)
    //
    //    [self.tableView setEditing:NO];
        self.tableView.setEditing(false, animated: false)//TODO: necessary?
    //    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.tableView.separatorStyle = .none
    //
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(reloadTableView)
    //                                                 name:@"FoodTypesUpdated"
    //                                               object:nil];
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadTableView),
                                               name: NSNotification.Name(rawValue: "FoodTypesUpdated"),
                                               object: nil)
    }
    
    @IBAction func handleTaps() {
        //TODO
    }
    
    @IBAction func reloadTableView() {
        //TODO
    }
    
    //MARK: - UITableViewDataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.fetchEvents()?.count ?? 0
        }
        return 0
    }
    
    //TODO: a lot of this method is pretty hacky... lots of force unwrapping, casting, use of NSDictionary...
    // Definitely create a coredata stack where
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
//        Event *event = [self.appDelegate fetchEvents][indexPath.row];
        guard let event = appDelegate.fetchEvents()?[indexPath.row] else { fatalError() }
//        NSDictionary *qualititesDictionary = [NSKeyedUnarchiver unarchivedObjectOfClass:NSDictionary.class
//                                                                              fromData:event.qualitiesDictionary
//                                                                                 error:nil];
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
            mealCell.mealDictionary = qualitiesDictionary as? [String : Bool]
            cell = mealCell
        } else {
            let poopCell = tableView.dequeueReusableCell(withIdentifier: "PoopCell", for: indexPath) as! PoopCell
            //TODO: uncomment once you implement PoopCell
            //poopCell.setQuality(qualititesDictionary["rating"])
            cell = poopCell
        }
        //TODO: just make sure this is implemented in the cells
//        cell.backgroundColor = [UIColor clearColor];
        return cell!
    }
    
    
}
