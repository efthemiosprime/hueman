//
//  NSDate+Offset.swift
//  Hueman
//
//  Created by Efthemios Prime on 1/7/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//


extension NSDate {
    func yearsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date: NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date)) year\(yearsFrom(date) > 1 ? "s" : "") ago"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date)) month\(monthsFrom(date) > 1 ? "s" : "") ago"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date)) week\(weeksFrom(date) > 1 ? "s" : "") ago"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date)) day\(daysFrom(date) > 1 ? "s" : "") ago"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date)) hour\(hoursFrom(date) > 1 ? "s" : "") ago"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date)) minute\(minutesFrom(date) > 1 ? "s" : "") ago" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date)) second\(secondsFrom(date) > 1 ? "s" : "") ago" }
        return ""
    }
    
    func offsetFrom2(date:NSDate) -> String {
        
        let dayHourMinuteSecond: NSCalendarUnit = [.Day, .Hour, .Minute, .Second]
        let difference = NSCalendar.currentCalendar().components(dayHourMinuteSecond, fromDate: date, toDate: self, options: [])
        
        let seconds = "\(difference.second)s"
        let minutes = "\(difference.minute)m" + " " + seconds
        let hours = "\(difference.hour)h" + " " + minutes
        let days = "\(difference.day)d" + " " + hours
        
        if difference.day    > 0 { return days }
        if difference.hour   > 0 { return hours }
        if difference.minute > 0 { return minutes }
        if difference.second > 0 { return seconds }
        return ""
    }
}
