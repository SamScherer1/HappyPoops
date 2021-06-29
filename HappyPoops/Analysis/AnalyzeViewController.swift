//
//  AnalyzeViewController.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 4/8/21.
//  Copyright © 2021 SamuelScherer. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AnalyzeViewController: UITableViewController {
    var container : PersistentContainer!

    var managedObjectContext : NSManagedObjectContext?
    var trackViewController : TrackViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black

        self.tableView.register(GraphCell.self, forCellReuseIdentifier: "GraphCell")
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath) as! GraphCell
        cell.container = self.container
        cell.reloadChartPoints()
        return cell
    }
}
