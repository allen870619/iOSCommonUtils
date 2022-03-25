//
//  File.swift
//  
//
//  Created by Lee Yen Lin on 2022/2/10.
//

import Foundation

public class DateUtils{
    /// str to Date
    ///
    /// format: yyyy-MM-dd
    public static func strDateToDate(_ str: String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: str) ?? Date.init(timeIntervalSince1970: TimeInterval(0))
    }
    
    /// str to Date
    ///
    /// format: yyyy-MM-dd HH:mm:ss
    public static func strDateTimeToDate(_ str: String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: str) ?? Date.init(timeIntervalSince1970: TimeInterval(0))
    }
    
    /// str to Date
    ///
    /// format: yyyy-MM-dd HH:mm:ss'.'SSS
    public static func strDateTimeMSToDate(_ str: String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss'.'SSS"
        return dateFormatter.date(from: str) ?? Date.init(timeIntervalSince1970: TimeInterval(0))
    }
    
    /// str to Date
    ///
    /// format: yyyy-MM-dd'T'HH:mm:ss'.'SSSSSS'Z'
    public static func strSqlToDate(_ str: String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'.'SSSSSS'Z'"
        return dateFormatter.date(from: str) ?? Date.init(timeIntervalSince1970: TimeInterval(0))
    }
    
    /// get total days of month
    public static func daysInMonth(year: Int, month: Int) -> Int {
        let date = DateUtils.strDateToDate("\(year)-\(month)-01")
        return date.daysInMonth
    }
}

public extension Date{
    /// yyyy-MM-dd
    func toDateString()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    /// yyyy-MM-dd HH:mm:ss
    func toDateTimeString()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    /// year
    var year: Int{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            return Int(dateFormatter.string(from: self)) ?? -1
        }
    }
    
    /// month
    var month: Int{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM"
            return Int(dateFormatter.string(from: self)) ?? -1
        }
    }
    
    /// day
    var day: Int{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            return Int(dateFormatter.string(from: self)) ?? -1
        }
    }
    
    /// total days of Month
    var daysInMonth: Int{
        get{
            if let interval = Calendar.current.dateInterval(of: .month, for: self) {
                return Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day ?? -1
            }else{
                return -1
            }
        }
    }
}
