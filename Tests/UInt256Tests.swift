import XCTest
@testable import UInt256_iOS

class UInt256Tests: XCTestCase {

    func testInit() {
        let a: UInt256 = UInt256(0)
        let b: UInt256 = UInt256(0x11111111)
        XCTAssertNotNil(a)
        XCTAssertNotNil(b)
    }

    func testAssign() {
        let a: UInt256 = UInt256([
            0x1111111111111111,
            0x2222222222222222,
            0x3333333333333333,
            0x4444444444444444]
        )
        let b = a
        let c = 1
        let d: UInt256 = 1
        XCTAssertEqual(
            b.description,
            """
            1111111111111111\
            2222222222222222\
            3333333333333333\
            4444444444444444
            """
        )
        XCTAssertEqual(a, b)
        XCTAssertEqual(UInt256(c), d)
    }

    func testEqual() {
        let a: UInt256 = UInt256(1)
        let b: UInt256 = UInt256(1)
        XCTAssertEqual(a, b)
    }

    func testCompare() {
        let a: UInt256 = UInt256([
            0x1111111111111111,
            0x2222222222222222,
            0x3333333333333333,
            0x4444444444444444
        ])
        let b: UInt256 = UInt256([
            0x5555555555555555,
            0x6666666666666666,
            0x7777777777777777,
            0x8888888888888888
        ])
        XCTAssertGreaterThan(b, a)
        XCTAssertTrue(b > a)
        XCTAssertTrue(b >= a)
        XCTAssertTrue(a < b)
        XCTAssertTrue(a <= b)
    }

    func testUnsignedInteger() {
        let a: UInt256 = UInt256.max
        let b: UInt256 = UInt256.min
        let m = b.magnitude
        XCTAssertEqual(m.description, """
        0000000000000000\
        0000000000000000\
        0000000000000000\
        0000000000000000
        """)
        XCTAssertEqual(a.description, """
        ffffffffffffffff\
        ffffffffffffffff\
        ffffffffffffffff\
        ffffffffffffffff
        """)
    }

    static var allTests = [
        ("testInit", testInit),
        ("testEqual", testEqual),
    ]
}
