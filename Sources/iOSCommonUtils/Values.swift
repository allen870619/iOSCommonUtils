//
//  Extension.swift
//  
//
//  Created by Lee Yen Lin on 2022/2/10.
//
import Foundation

public extension String{
    /// parse raw string to localize sting
    func toNSL() -> String{
        return NSLocalizedString(self, comment: "NS_\(self)")
    }
}

public extension Double {
    func rounding(_ decimal: Int) -> Double {
        let numberOfDigits = pow(10.0, Double(decimal))
        return (self * numberOfDigits).rounded(.toNearestOrAwayFromZero) / numberOfDigits
    }
}
