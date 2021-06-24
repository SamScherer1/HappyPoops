//
//  TestCharts.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 8/27/20.
//  Copyright © 2020 SamuelScherer. All rights reserved.
//

import Foundation
import Charts

struct DateValuePoint {
    var date:Date
    var value:Double
}

class Chart: LineChartView {
    var datePointsArray = [DateValuePoint]()
    var resolution = TimeResolution.all
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        self.leftAxis.granularity = 1.0
        self.leftAxis.granularityEnabled = true
        self.rightAxis.enabled = false
        self.xAxis.labelPosition = XAxis.LabelPosition.bottom
        self.legend.enabled = false
        self.xAxis.valueFormatter = XAxisFormatter()
        self.noDataText = "" // Hack to fix noDataText showing with graph
        self.xAxis.labelTextColor = UIColor.white
        self.leftAxis.labelTextColor = UIColor.white
        self.xAxis.drawGridLinesEnabled = false
        self.leftAxis.drawGridLinesEnabled = false
        self.xAxis.drawAxisLineEnabled = false
        self.leftAxis.drawAxisLineEnabled = false
        self.extraRightOffset = 20.0
    }
    
    public func set(dates:[Date], values:[NSValue]) {
        if let values = values as? [Double] {
            let pointsArray = zip(dates, values)
            for (date, point) in pointsArray {
                self.datePointsArray.append(DateValuePoint(date: date, value: point))
            }
            self.updateOnMainThread()
        }
    }
    
    func doublesFrom(dates:[Date]) -> Array<Double> {
        var doublesArray = Array<Double>()
        let startDate = dates.first
        for completionDate in dates {
            let secondsSinceStart = completionDate.timeIntervalSince(startDate!)
            doublesArray.append(secondsSinceStart)
        }
        return doublesArray
    }
    
    func updateOnMainThread() {
        DispatchQueue.main.async {
            self.update()
        }
    }
    
    func update() {
        var pointsArray = [ChartDataEntry]()
        guard let startDate = self.datePointsArray.first?.date else {
            self.reloadInputViews()
            return
        }
        if self.resolution == .all {
            for datePoint in self.datePointsArray {
                pointsArray.append(ChartDataEntry(x:datePoint.date.timeIntervalSince(startDate), y:datePoint.value))
            }
        } else {
            var runningSum = 0.0
            var sumCount = 0
            var beginSummingPeriod : Date = startDate
            
            for point in self.datePointsArray {
                if (self.beginningOf(resolution: self.resolution, date: point.date) <= beginSummingPeriod) {
                    // If the current point lies in the same day, week or month of the last one, add to the tallies
                    sumCount += 1
                    runningSum = runningSum + point.value
                } else {
                    pointsArray.append(ChartDataEntry(x: beginSummingPeriod.timeIntervalSince(startDate), y: runningSum/Double(sumCount)))
                    sumCount = 1
                    runningSum = point.value
                    beginSummingPeriod = self.beginningOf(resolution: self.resolution, date: point.date)
                }
            }
            pointsArray.append(ChartDataEntry(x: beginSummingPeriod.timeIntervalSince(startDate), y: runningSum/Double(sumCount)))
        }
        self.data = LineChartData(dataSet: self.dataSetWithEntries(entries: pointsArray))

        // Calculate range of data for x and y axis labels
        var yMax = 0.0
        var yMin = 24.0
        
        for point in pointsArray {
            if point.y < yMin {
                yMin = point.y
            }
            if point.y > yMax {
                yMax = point.y
            }
        }
        
        let range = yMax - yMin
        if (range > 20) {
            self.leftAxis.granularity = 12.0
        } else if (range > 12 && range <= 20) {
            self.leftAxis.granularity = 6.0
        } else if (range >= 2 && range <= 12) {
            self.leftAxis.granularity = 1.0
        } else if (range < 2 && range > 1) {
            self.leftAxis.granularity = 0.5
        } else if (range == 0) {
            self.leftAxis.granularity = 0.5
        } else {
            self.leftAxis.granularity = 0.25
        }
        
        let xAxisFormatter = self.xAxis.valueFormatter as! XAxisFormatter
        xAxisFormatter.xCount = pointsArray.count
        xAxisFormatter.startDate = startDate
        
        self.reloadInputViews()
    }

    func beginningOf(resolution:(TimeResolution), date:(Date)) -> Date {
        let cal = NSCalendar.current
        var dateComponents : DateComponents?
        switch resolution {
        case .day:
            dateComponents = cal.dateComponents([.day, .year, .month,.year], from: date)
        case .week:
            dateComponents = cal.dateComponents([.weekOfYear,.yearForWeekOfYear], from: date)
        case .month:
            dateComponents = cal.dateComponents([.month, .year], from: date)
        default:
            print("finish implementation")
        }
        return cal.date(from: dateComponents!)!
    }
    
    func set(resolution:TimeResolution) {
        let xAxisFormatter = self.xAxis.valueFormatter as! XAxisFormatter
        xAxisFormatter.resolution = resolution
        self.resolution = resolution
        self.updateOnMainThread()
    }
    
    func clearChartData() {
        let nilValues:[ChartDataEntry] = []
        let set = self.dataSetWithEntries(entries: nilValues)
        self.data = LineChartData(dataSet: set)
    }
    
    func dataSetWithEntries(entries:[ChartDataEntry]) -> LineChartDataSet {
        let set = LineChartDataSet(entries: entries, label: "DataSet 1")
        set.drawIconsEnabled = false

        set.setColor(.black)
        set.setCircleColor(.black)
        set.lineWidth = 1
        set.circleRadius = 3
        set.drawCircleHoleEnabled = false
        set.valueFont = .systemFont(ofSize: 9)

        set.formSize = 15
        set.drawValuesEnabled = false
        set.drawCirclesEnabled = false
        set.setColor(UIColor.white, alpha: 1)
        //set.cubicIntensity = 0.2
        //set.mode = LineChartDataSet.Mode.cubicBezier
        return set
    }
}
