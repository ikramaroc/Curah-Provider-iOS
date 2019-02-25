//
//  Extensions.swift
//  Curah
//
//  Created by Netset on 17/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController
{
    
    
    func convertToLocalDateFormatOnlyTime(utcDate:String) -> String
    {
        if utcDate.count == 0
        {
            return ""
        }
        else
        {
            // create dateFormatter with UTC time format
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            let dt = dateFormatter.date(from: utcDate)
            dateFormatter.timeZone = TimeZone.current
            
            let finalDateStr = dateFormatter.string(from: dt!)
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            //  return dateFormatter.date(from: differenceDate!)
            return Date().offsetLong(date: dateFormatter.date(from: finalDateStr)!)
        }
    }
}



extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    func offsetLong(date: Date) -> String {
        if years(from: date)   > 0
        {
            if months(from: date)  < 12
            {
                return months(from: date) > 1 ? "\(months(from: date)) months ago" : "\(months(from: date)) month ago"
            }
            else
            {
                return years(from: date) > 1 ? "\(years(from: date)) years ago" : "\(years(from: date)) year ago"
            }
        }
        if months(from: date)  > 0
        {
            if weeks(from: date)   < 4
            {
                return weeks(from: date) > 1 ? "\(weeks(from: date)) weeks ago" : "\(weeks(from: date)) week ago"
            }
            else
            {
                return months(from: date) > 1 ? "\(months(from: date)) months ago" : "\(months(from: date)) month ago"
            }
        }
        if weeks(from: date)   > 0
        {
            if days(from: date)    < 7
            {
                return days(from: date) > 1 ? "\(days(from: date)) days ago" : "\(days(from: date)) day ago"
            }
            else
            {
                return weeks(from: date) > 1 ? "\(weeks(from: date)) weeks ago" : "\(weeks(from: date)) week ago"
            }
        }
        if days(from: date)    > 0
        {
            if hours(from: date)   < 24
            {
                return hours(from: date) > 1 ? "\(hours(from: date)) hours ago" : "\(hours(from: date)) hour ago"
            }
            else
            {
                return days(from: date) > 1 ? "\(days(from: date)) days ago" : "\(days(from: date)) day ago"
            }
        }
        if hours(from: date)   > 0
        {
            if minutes(from: date) < 59
            {
                return minutes(from: date) > 1 ? "\(minutes(from: date)) minutes ago" : "\(minutes(from: date)) minute ago"
            }
            else
            {
                return hours(from: date) > 1 ? "\(hours(from: date)) hours ago" : "\(hours(from: date)) hour ago"
            }
        }
        if minutes(from: date) > 0
        {
            if seconds(from: date) < 59
            {
                return seconds(from: date) > 1 ? "\(seconds(from: date)) seconds ago" : "\(seconds(from: date)) second ago"
            }
            else
            {
                return minutes(from: date) > 1 ? "\(minutes(from: date)) minutes ago" : "\(minutes(from: date)) minute ago"
            }
        }
        if seconds(from: date) > 0
        {
            return seconds(from: date) > 1 ? "\(seconds(from: date)) seconds ago" : "\(seconds(from: date)) second ago"
        }
        
        return "just now"
    }
    
    
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   == 1
        {
            return "\(years(from: date)) year"
        }
        else if years(from: date)   > 1
        {
            return "\(years(from: date)) years"
        }
        if months(from: date)  == 1
        {
            return "\(months(from: date)) month"
        }
        else if months(from: date)  > 1
        {
            return "\(months(from: date)) month"
        }
        if weeks(from: date)   == 1
        {
            return "\(weeks(from: date)) week"
        }
        else if weeks(from: date)   > 1
        {
            return "\(weeks(from: date)) weeks"
        }
        if days(from: date)    == 1
        {
            return "\(days(from: date)) day"
        }
        else if days(from: date)    > 1
        {
            return "\(days(from: date)) days"
        }
        if hours(from: date)   == 1
        {
            return "\(hours(from: date)) hour"
        }
        else if hours(from: date)   > 1
        {
            return "\(hours(from: date)) hours"
        }
        if minutes(from: date) == 1
        {
            return "\(minutes(from: date)) minute"
        }
        else if minutes(from: date) > 1
        {
            return "\(minutes(from: date)) minutes"
        }
        return ""
    }
}

