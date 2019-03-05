//
//  CalendarModel.swift
//  SoloProjectFireBase
//
//  Created by Olimpia on 3/3/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import Foundation

final class getCalendar {

 static func arrayOfDates() -> NSArray {
    
    let numberOfDays: Int = 14
    let startDate = Date()
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "EEE d/M"
    let calendar = Calendar.current
    var offset = DateComponents()
    var dates: [Any] = [formatter.string(from: startDate)]
    
    for i in 1..<numberOfDays {
        offset.day = i
        let nextDay: Date? = calendar.date(byAdding: offset, to: startDate)
        let nextDayString = formatter.string(from: nextDay!)
        dates.append(nextDayString)
    }
    return dates as NSArray
}
}
