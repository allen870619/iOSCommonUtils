import XCTest
@testable import iOSCommonUtils

final class UIObjectsTests: XCTestCase {
   
    func testColorConvert(){
        let color = UIColor.rgbToUIColor(0xFFFFFF)
        let c = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        XCTAssertEqual(color, c)
        let color1 = UIColor.rgbToUIColor(0x000000)
        let c1 = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        XCTAssertEqual(color1, c1)
        let color2 = UIColor.rgbToUIColor(0x333333)
        let c2 = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        XCTAssertEqual(color2.hashValue, c2.hashValue)
    }
}
