import XCTest
@testable import UInt256

class UInt256Tests: XCTestCase {

    func testInit() {
        let a: UInt256 = UInt256(0)
        let b: UInt256 = UInt256(0x11111111)
        let c: UInt256 = UInt256(-1)
        XCTAssertNotNil(a)
        XCTAssertNotNil(b)
        XCTAssertEqual(UInt256(), a)
        XCTAssertEqual(0, a)
        XCTAssertEqual(c, UInt256.max)
    }
    
    func testInit0() {
        let a = UInt256([0, 0])
        let b = UInt256([0, 0x11111111])
        let c = UInt256(b[2...3])
        
        XCTAssertEqual(a, 0)
        XCTAssertEqual(b, c)
    }

    func testInit1() {
        var a = UInt256(exactly: -1)
        XCTAssertEqual(a, nil)
        a = UInt256(clamping: -1)
        XCTAssertEqual(a, UInt256.min)
        a = UInt256(truncatingIfNeeded: -1)
        XCTAssertEqual(a, UInt256([0, 0, 0, UInt64.max]))
        a = UInt256(_truncatingBits: UInt.max)
        XCTAssertEqual(a, UInt256([0, 0, 0, UInt64.max]))

        a = UInt256(exactly: 1)
        XCTAssertEqual(a, 1)
        a = UInt256(clamping: 1)
        XCTAssertEqual(a, 1)
        a = UInt256(truncatingIfNeeded: 1)
        XCTAssertEqual(a, UInt256([0, 0, 0, 1]))
        
        a = UInt256(198223.1)
        XCTAssertEqual(a, UInt256([0, 0, 0, 198223]))
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
        var e = UInt256(a)
        e[0] = 0
        e[1] = 0
        e[2] = 0
        e[3] = 1
        XCTAssertEqual(e, d)
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

    func testMinMax() {
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
}
