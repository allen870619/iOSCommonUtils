import XCTest
@testable import iOSCommonUtils

final class iOSCommonUtilsTests: XCTestCase {
    func testDateExtension(){
        let date = Date()
        XCTAssertEqual(date.year, 2022)
        XCTAssertEqual(date.month, 3)
        XCTAssertEqual(date.day, 8)
    }
}
