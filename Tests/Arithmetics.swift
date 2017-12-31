//
// Created by MrYu87 on 12/30/17.
// Copyright (c) 2017 MrYu87. All rights reserved.
//

import XCTest
@testable import UInt256

class UInt256ArithmeticTests: XCTestCase {

    func testAddition() {
        let a: UInt256 = UInt256.max
        let b: UInt256 = 1
        let c: UInt256 = UInt256.max
        let d: UInt256 = a &+ b
        let e: UInt256 = a &+ c
        XCTAssertEqual(d, UInt256.min)
        XCTAssertEqual(e.description, """
        ffffffffffffffff\
        ffffffffffffffff\
        ffffffffffffffff\
        fffffffffffffffe
        """)
    }

    func testAddtion1() {
        let a: UInt256 = 1
        let b: UInt256 = 2
        let c: UInt256 = UInt256([
            0xffffffffffffffff,
            0xffffffffffffffff,
            0xffffffffffffffff,
            0xfffffffffffffffd
        ])
        let d: UInt256 = a &+ b
        let e: UInt256 = a &+ c
        XCTAssertEqual(d, 3)
        XCTAssertEqual(e.description, """
        ffffffffffffffff\
        ffffffffffffffff\
        ffffffffffffffff\
        fffffffffffffffe
        """)
    }

    func testSubtraction() {
        let a: UInt256 = UInt256.max
        let b: UInt256 = 1
        let c: UInt256 = UInt256.max
        let d: UInt256 = c &- a
        let e: UInt256 = b &- a
        XCTAssertEqual(d, UInt256.min)
        XCTAssertEqual(e.description, """
        0000000000000000\
        0000000000000000\
        0000000000000000\
        0000000000000002
        """)
    }

    func testSubtraction1() {
        let a: UInt256 = 1
        let b: UInt256 = 2
        let c: UInt256 = UInt256([
            0xffffffffffffffff,
            0xffffffffffffffff,
            0xffffffffffffffff,
            0xfffffffffffffffd
        ])
        let d: UInt256 = b &- a
        let e: UInt256 = c &- b
        XCTAssertEqual(d, 1)
        XCTAssertEqual(e.description, """
        ffffffffffffffff\
        ffffffffffffffff\
        ffffffffffffffff\
        fffffffffffffffb
        """)
    }

    func testMultiplication() {
        let a = UInt256([1, 1, 1, 1])
        let b = UInt256([0, 0, 0, 5])
        XCTAssertEqual(a * b, UInt256([5, 5, 5, 5]))
        let c = UInt256([1, 1, 1, 1])
        let d = UInt256([0, 0, 0, 0xffffffffffffffff])
        XCTAssertEqual(c * d, UInt256.max)
        let e = UInt256([
            0x5555555555555555,
            0x5555555555555555,
            0x5555555555555555,
            0x5555555555555555,
        ])
        let f = UInt256([0, 0, 0, 2])
        XCTAssertEqual(e * f, UInt256([
            0xaaaaaaaaaaaaaaaa,
            0xaaaaaaaaaaaaaaaa,
            0xaaaaaaaaaaaaaaaa,
            0xaaaaaaaaaaaaaaaa,
        ]))
    }

    func testModulo() {
        let a = UInt256([1, 0, 0, 0])
        let b = UInt256(17)
        XCTAssertEqual((a % b), 1)
        let c = UInt256([0xffff, 0, 0, 0])
        let d = UInt256(23)
        XCTAssertEqual((c % d), 3)
        let e = UInt256([0xffffffff, 0, 0, 0])
        let f = UInt256(29)
        XCTAssertEqual((e % f), 10)
        let g = UInt256.max
        let h = UInt256(103889)
        XCTAssertEqual((g % h), 101614)
    }

    func testDivision() {
        let a = UInt256.max
        XCTAssertEqual(a / UInt256(UInt64.max), UInt256([1, 1, 1, 1]))
        XCTAssertEqual(a / UInt256(UInt32.max), UInt256([
            0x0000000100000001,
            0x0000000100000001,
            0x0000000100000001,
            0x0000000100000001,
        ]))
    }
}
