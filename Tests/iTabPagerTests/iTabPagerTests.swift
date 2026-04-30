import XCTest
@testable import iTabPager

final class LerpTests: XCTestCase {
    func test_lerp_atZero() {
        XCTAssertEqual(lerp(0, 10, 0), 0)
    }
    func test_lerp_atOne() {
        XCTAssertEqual(lerp(0, 10, 1), 10)
    }
    func test_lerp_midpoint() {
        XCTAssertEqual(lerp(0, 10, 0.5), 5)
    }
    func test_lerp_arbitrary() {
        XCTAssertEqual(lerp(100, 200, 0.3), 130, accuracy: 0.001)
    }
    func test_lerp_reverseDirection() {
        XCTAssertEqual(lerp(10, 0, 0.3), 7, accuracy: 0.001)
    }
}
