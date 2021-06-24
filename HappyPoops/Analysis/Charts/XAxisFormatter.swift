//
//  SAMXAxisFormatter.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 8/27/20.
//  Copyright © 2020 SamuelScherer. All rights reserved.
//

import Foundation
import Charts

class XAxisFormatter : IAxisValueFormatter {
    public var xCount = 0
    public var startDate = Date()
    public var resolution = TimeResolution.all
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.short
        let calendar = NSCalendar.current
        
        if (resolution == .all) {
            let calComponents = Set.init(arrayLiteral: Calendar.Component.day, Calendar.Component.month, Calendar.Component.year);
            var dateComponents = calendar.dateComponents(calComponents, from: startDate as Date)
            dateComponents.setValue(dateComponents.day! + Int(value/86400), for: Calendar.Component.day)
            return dateFormatter.string(from: calendar.date(from: dateComponents)!)
        } else if (resolution == .day) {
            let calComponents = Set.init(arrayLiteral: Calendar.Component.day, Calendar.Component.month, Calendar.Component.year);
            var dateComponents = calendar.dateComponents(calComponents, from: startDate as Date)
            dateComponents.setValue(dateComponents.day! + Int(value/86400), for: Calendar.Component.day)
            return dateFormatter.string(from: calendar.date(from: dateComponents)!)
        } else if (resolution == .week) {
            let calComponents = Set.init(arrayLiteral: Calendar.Component.weekOfYear, Calendar.Component.yearForWeekOfYear);
            var dateComponents = calendar.dateComponents(calComponents, from: startDate as Date)
            dateComponents.setValue(dateComponents.weekOfYear! + Int(value), for: Calendar.Component.weekOfYear)
            //NSLog("dateString: %@",dateFormatter.string(from: calendar.date(from: dateComponents)!))
            return dateFormatter.string(from: calendar.date(from: dateComponents)!)
        } else if (resolution == .month) {
            let calComponents = Set.init(arrayLiteral: Calendar.Component.month, Calendar.Component.year);
            var dateComponents = calendar.dateComponents(calComponents, from: startDate as Date)
            dateComponents.setValue(dateComponents.month! + Int(value), for: Calendar.Component.month)
            return dateFormatter.string(from: calendar.date(from: dateComponents)!)
        }
        return "err"
    }
}

