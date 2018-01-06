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
        XCTAssertEqual(e.hashValue, e.toHexString().hashValue)
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
        var f = 10 as UInt256
        let g = 1 as UInt256
        f -= g
        XCTAssertEqual(f, 9)
        f += g
        XCTAssertEqual(f, 10)
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
        var e = UInt256([
            0x5555555555555555,
            0x5555555555555555,
            0x5555555555555555,
            0x5555555555555555,
        ])
        let f = UInt256([0, 0, 0, 2])
        e *= f
        XCTAssertEqual(e, UInt256([
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
        var g = UInt256.max
        let h = UInt256(103889)
        g %= h
        XCTAssertEqual(g, 101614)
        let i = UInt256(15)
        let j = UInt256.min
        XCTAssertEqual(i % j, 0)
        let k = UInt256(15)
        let l = UInt256(1)
        XCTAssertEqual(k % l, 0)
    }

    func generateRandomUInt64() -> UInt64 {
        let x0 = UInt64(arc4random())
        let x1 = UInt64(arc4random())
        return x0 << 32 | x1
    }

    func testDivision() {
        var a = UInt256.max
        XCTAssertEqual(a / UInt256(UInt64.max), UInt256([1, 1, 1, 1]))
        a /= UInt256(UInt32.max)
        XCTAssertEqual(a, UInt256([
            0x0000000100000001,
            0x0000000100000001,
            0x0000000100000001,
            0x0000000100000001,
        ]))

        XCTAssertEqual(a / UInt256.max, 0)
        XCTAssertEqual(a / a, 1)
        XCTAssertEqual(a % UInt256.max, a)
        XCTAssertEqual(a % a, 0)
    }
    
    func testArithmetic() {
        for _ in 1..<10 {
            let b = UInt256([
                generateRandomUInt64(),
                generateRandomUInt64(),
                generateRandomUInt64(),
                generateRandomUInt64()
            ])
            let c = UInt256([
                0,
                0,
                generateRandomUInt64(),
                generateRandomUInt64()
            ])
            let result = b / c
            let remainder = b % c
            XCTAssertEqual(result * c + remainder, b)
        }
    }

    func testKaratsuba() {
        let a = UInt256.max
        let b = UInt256.max
        let (high, low) = UInt256.karatsuba(a, b)
        XCTAssertEqual(high, UInt256(-2))
        XCTAssertEqual(low, UInt256(1))
    }
}
