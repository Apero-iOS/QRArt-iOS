//
//  Date+.swift
//  BaseVIPER
//
//  Created by Quang Ly Hoang on 11/07/2022.
//

import Foundation

extension Date {
    static var today: Date { return Date().today }
    static var yesterday: Date { return Date().yesterday }
    static var dayBeforeYesterday: Date { return Date().dayBeforeYesterday }
    static var currentMonth: Date { return Date().currentMonth }
    static var lastMonth: Date { return Date().lastMonth }
    static var monthBeforeLast: Date { return Date().monthBeforeLast }
    
    var currentMonth: Date {
        return Calendar.current.date(byAdding: .month, value: 0, to: Date())!
    }
    var lastMonth: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: Date())!
    }
    var monthBeforeLast: Date {
        return Calendar.current.date(byAdding: .month, value: -2, to: Date())!
    }
    var dayBeforeYesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: noon)!
    }
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var today: Date {
        return Calendar.current.date(byAdding: .day, value: 0, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var startOfDay: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return  calendar.date(from: components)!
    }
    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return  calendar.date(from: components)!
    }
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
    func ddMMyyyy() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy"
        dateFormater.locale = Locale.current
        return dateFormater.string(from: self)
    }

    func yyyyMMdd() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        dateFormater.locale = Locale.current
        return dateFormater.string(from: self)
    }

    func HHmmss() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH:mm:ss"
        dateFormater.locale = Locale.current
        return dateFormater.string(from: self)
    }
    
    func toString(format: String = "yyyy-MM-dd  HH:mm") -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = format
        dateFormater.locale = Locale.current
        return dateFormater.string(from: self)
    }

    static func date(fullString: String) -> Date? {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        dateFormater.locale = Locale.current
        return dateFormater.date(from: fullString)
    }

    static func date(yyyyMMddString: String) -> Date? {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        dateFormater.locale = Locale.current
        return dateFormater.date(from: yyyyMMddString)
    }

    static func dayOfWeek(day: Day, numberOfWeek: Int) -> Date {
        var date = Date()
        let calendar = Calendar.current.dateComponents([.weekday], from: date)

        let currentDayOfWeek = ((calendar.weekday == 1) ? 8 : calendar.weekday)!
        let expectedDayOfWeek = (day.rawValue == 1) ? 8 : day.rawValue

        let dayIntervalInSecond: Int = (expectedDayOfWeek - currentDayOfWeek) * 24 * 3600

        let weekIntervalInSecond: Int = (numberOfWeek * 7 * 24 * 3600)

        let totalIntervalInSecond: Int = dayIntervalInSecond + weekIntervalInSecond
        date.addTimeInterval(TimeInterval(totalIntervalInSecond))
        return date
    }

    static func numberOfDayToExpire(fromDate: Date, toDate: Date) -> Int {
        guard toDate > fromDate else {
            return 0
        }
        let dateInterval = DateInterval(start: fromDate, end: toDate)
        let duration = dateInterval.duration
        let remainDays = duration / 3600 / 24
        return Int(remainDays)
    }
}

enum Day: Int {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}
