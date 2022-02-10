//
//  File.swift
//  
//
//  Created by Lee Yen Lin on 2022/2/10.
//

import Foundation

public class DateUtils{
    public static func strDateToDate(_ str: String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: str) ?? Date.init(timeIntervalSince1970: TimeInterval(0))
    }
    
    public static func strDateTimeToDate(_ str: String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: str) ?? Date.init(timeIntervalSince1970: TimeInterval(0))
    }
    
    public static func strDateTimeMSToDate(_ str: String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss'.'SSS"
        return dateFormatter.date(from: str) ?? Date.init(timeIntervalSince1970: TimeInterval(0))
    }
    
    public static func strSqlToDate(_ str: String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'.'SSSSSS'Z'"
        return dateFormatter.date(from: str) ?? Date.init(timeIntervalSince1970: TimeInterval(0))
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
    func year() -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return Int(dateFormatter.string(from: self)) ?? -1
    }
}
