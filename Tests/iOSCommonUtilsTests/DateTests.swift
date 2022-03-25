//
//  DateTests.swift
//  
//
//  Created by Lee Yen Lin on 2022/3/25.
//

import XCTest
import iOSCommonUtils

class DateTests: XCTestCase {
    
    func testDateExtension(){
        let date = Date()
        let m = date.month < 10 ? "0\(date.month)" : "\(date.month)"
        let d = date.day < 10 ? "0\(date.day)" : "\(date.day)"
        let str = "\(date.year)-\(m)-\(d)"
        XCTAssertEqual(str, date.toDateString())
        
        let date2 = DateUtils.strDateToDate("2022-06-19")
        XCTAssertEqual(date2.daysInMonth, 30)
    }
    
}
