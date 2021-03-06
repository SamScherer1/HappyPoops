//
//  GraphCell.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 4/4/21.
//  Copyright © 2021 SamuelScherer. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GraphCell: UITableViewCell, UITableViewDataSource {
    
    var container: PersistentContainer!
    var chart = Chart()
    var titleLabel = UILabel()
    var xResolutionSC = UISegmentedControl()
    var analysisTableView = ContentSizedTableView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        
        let backgroundRectangle = UIView()
        self.contentView.addSubview(backgroundRectangle)
        backgroundRectangle.translatesAutoresizingMaskIntoConstraints = false
        backgroundRectangle.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15).isActive = true
        backgroundRectangle.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        backgroundRectangle.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -15).isActive = true
        backgroundRectangle.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
        backgroundRectangle.backgroundColor = UIColor.halfTransparentDarkColor()
        backgroundRectangle.layer.cornerRadius = 15
        
        backgroundRectangle.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.font = UIFont.systemFont(ofSize: 24)
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.text = "Poop Quality"
        self.titleLabel.topAnchor.constraint(equalTo: backgroundRectangle.topAnchor, constant: 15).isActive = true
        self.titleLabel.centerXAnchor.constraint(equalTo: backgroundRectangle.centerXAnchor).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        let chartWrapper = UIView()
        chartWrapper.translatesAutoresizingMaskIntoConstraints = false
        backgroundRectangle.addSubview(chartWrapper)
        chartWrapper.leftAnchor.constraint(equalTo: backgroundRectangle.leftAnchor, constant: 15.0).isActive = true
        chartWrapper.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0).isActive = true
        chartWrapper.rightAnchor.constraint(equalTo: backgroundRectangle.rightAnchor, constant: -15.0).isActive = true
        chartWrapper.widthAnchor.constraint(equalTo: chartWrapper.heightAnchor).isActive = true
        
        self.chart.translatesAutoresizingMaskIntoConstraints = false
        chartWrapper.addSubview(self.chart)
        self.chart.topAnchor.constraint(equalTo: chartWrapper.topAnchor).isActive = true
        self.chart.leftAnchor.constraint(equalTo: chartWrapper.leftAnchor).isActive = true
        self.chart.rightAnchor.constraint(equalTo: chartWrapper.rightAnchor).isActive = true
        self.chart.bottomAnchor.constraint(equalTo: chartWrapper.bottomAnchor).isActive = true
        
        self.xResolutionSC = UISegmentedControl.init(items: ["All", "Day", "Week", "Month"])
        self.xResolutionSC.translatesAutoresizingMaskIntoConstraints = false
        backgroundRectangle.addSubview(self.xResolutionSC)
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.xResolutionSC.setTitleTextAttributes(attributes, for: UIControl.State.normal)
        let highlightedAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        self.xResolutionSC.setTitleTextAttributes(highlightedAttributes, for: UIControl.State.normal)
        self.xResolutionSC.topAnchor.constraint(equalTo: chartWrapper.bottomAnchor, constant: 15).isActive = true
        self.xResolutionSC.leftAnchor.constraint(equalTo: chartWrapper.leftAnchor).isActive = true
        self.xResolutionSC.rightAnchor.constraint(equalTo: chartWrapper.rightAnchor).isActive = true
        self.xResolutionSC.selectedSegmentIndex = 0
        
        self.xResolutionSC.addTarget(self, action: #selector(handleResolutionChange), for: .valueChanged)
        
        self.analysisTableView.translatesAutoresizingMaskIntoConstraints = false
        backgroundRectangle.addSubview(self.analysisTableView)
        self.analysisTableView.backgroundColor = UIColor.clear
        self.analysisTableView.isScrollEnabled = false
        self.analysisTableView.dataSource = self
        self.analysisTableView.register(InsightTableViewCell.self, forCellReuseIdentifier: "InsightCell")
        
        self.analysisTableView.topAnchor.constraint(equalTo: self.xResolutionSC.bottomAnchor, constant: 15).isActive = true
        self.analysisTableView.leftAnchor.constraint(equalTo: chartWrapper.leftAnchor).isActive = true
        self.analysisTableView.rightAnchor.constraint(equalTo: chartWrapper.rightAnchor).isActive = true
        self.analysisTableView.bottomAnchor.constraint(equalTo: backgroundRectangle.bottomAnchor, constant: -15.0).isActive = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadChartPoints),
                                               name: NSNotification.Name(rawValue: "EventsUpdated"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadInsightTableView),
                                               name: NSNotification.Name(rawValue: "FoodTypesUpdated"),
                                               object: nil)
    }
    
    @IBAction func reloadChartPoints() {
        var dateArray = [Date]()
        var valueArray = [NSValue]()
        if let eventArray = self.container.fetchEvents() {
            for event in eventArray {
                if !event.isMeal {
                    do {
                        let qualitiesDictionary = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSDictionary.self, from: event.qualitiesDictionary!)
                        valueArray.append(qualitiesDictionary?.object(forKey: "rating") as! NSValue)
                        dateArray.append(event.date!)
                    } catch {
                        print("failed to unarchive qualitiesDictionary")
                    }
                }
            }
        }
        self.chart.set(dates: dateArray, values: valueArray)
    }
    
    @IBAction func reloadInsightTableView() {
        self.analysisTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.container.fetchFoodTypes()?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InsightCell", for: indexPath) as! InsightTableViewCell
        cell.backgroundColor = UIColor.clear
        if let foodTypes = self.container.fetchFoodTypes() {
            if let name = foodTypes[indexPath.row].name {
                cell.titleLabel.text = name
            }
            do {
                if let archivedColor = foodTypes[indexPath.row].color {
                    cell.arrowView.tintColor = try NSKeyedUnarchiver.unarchivedObject(ofClass:UIColor.self ,
                                                                                      from:archivedColor)
                }
            } catch {
                print("failed to unarchive cellColor")
            }
        }
        return cell
    }
    
    @IBAction func handleResolutionChange() {
        self.chart.set(resolution: TimeResolution(rawValue: self.xResolutionSC.selectedSegmentIndex) ?? .all)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
