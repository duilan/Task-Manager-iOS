//
//  Date+Ext.swift
//  Task Manager
//
//  Created by Duilan on 09/12/21.
//

import Foundation

extension Date {
    
    func countFrom(date: Date) -> String {
        
        let YearMonthDayHourMinuteSecond: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(YearMonthDayHourMinuteSecond, from: date, to: self)
        
        //let seconds = "\(difference.second ?? 0) seg"
        let minutes = "\(difference.minute ?? 0) min"
        let hours = "\(difference.hour ?? 0) hrs"
        let days = "\(difference.day ?? 0) dias"
        let months = "\(difference.month ?? 0) Meses"
        let years = "\(difference.year ?? 0) Años"
        
        if let year = difference.year, year         > 0 { return years }
        if let month = difference.month, month      > 0 { return months }
        if let day = difference.day, day            > 0 { return days }
        if let hour = difference.hour, hour         > 0 { return hours }
        if let minute = difference.minute, minute   > 0 { return minutes }
        if let second = difference.second, second < 60  { return "unos segundos" }
        
        return ""
    }
    
}
