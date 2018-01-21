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
    
    func generateRandomUInt64() -> UInt64 {
        let x0 = UInt64(arc4random())
        let x1 = UInt64(arc4random())
        return x0 << 32 | x1
    }

    func generateUInt256() -> UInt256 {
        return UInt256([
            generateRandomUInt64(),
            generateRandomUInt64(),
            generateRandomUInt64(),
            generateRandomUInt64()
        ])
    }

    func testArithmetic() {
        for _ in 1..<10 {
            let b = generateUInt256()
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

    func testArithmetic1() {
        for _ in 1..<50 {
            let a = generateUInt256()
            let b = generateUInt256()
            let c = a.multipliedFullWidth(by: b)
            print("\(a) times \(b) equals \(c)")
            let (q, r) = a.dividingFullWidth(c)
            XCTAssertEqual(q, b)
            XCTAssertEqual(r, 0)
        }
    }

    func testSimpleFullWidthDivision() {
        let hi = UInt256(1)
        var lo = UInt256(0)
        let a = UInt256([0x8000000000000000, 0, 0, 1])
        var (q, r) = a.dividingFullWidth((hi, lo))
        XCTAssertEqual(q, 1)
        XCTAssertEqual(r, UInt256([0x7fffffffffffffff, UInt64.max, UInt64.max, UInt64.max]))

        lo = UInt256(2)
        (q, r) = a.dividingFullWidth((hi, lo))
        XCTAssertEqual(q, 2)
        XCTAssertEqual(r, 0)
    }

    func testSimpleFullWidthDivision1() {
        let hi = UInt256(1)
        let lo = UInt256(2)
        let a = UInt256([0x8000000000000000, 0, 0, 0])
        let (q, r) = a.dividingFullWidth((hi, lo))
        XCTAssertEqual(q, 2)
        XCTAssertEqual(r, 2)
    }

    func testSimpleFullWidthDivision2() {
        let hi = UInt256(1)
        let lo = UInt256(3)
        let a = UInt256([0x8000000000000000, 0, 0, 0])
        let (q, r) = a.dividingFullWidth((hi, lo + a))
        XCTAssertEqual(q, 3)
        XCTAssertEqual(r, 3)
    }

    func testMaxArithmetic() {
        // test maximum
        let a = UInt256.max
        let b = UInt256.max
        let (high, low) = UInt256.karatsuba(a, b)
        XCTAssertEqual(high, UInt256(-2))
        XCTAssertEqual(low, UInt256(1))
        let (q, _) = a.dividingFullWidth((high: high, low: low))
        XCTAssertEqual(q, b)
    }

    /// the following multiplication tests are generated randomly
    func testMultiplication1() {
        let (a, b, h, l) = (
            a: UInt256([0xde7b0104807b1f40, 0x2c6ac9b8ead87a05, 0x743419685d3c3f73, 0x0663a1ee55b68583]),
            b: UInt256([0x318690dfe2ea68f0, 0xf063fe3c31f3eb56, 0x7955ef26c4acef56, 0x7dcaff8b493920b4]),
            h: UInt256([0x2b0a7d7c27df8b27, 0x151b246866abaeab, 0x539c45991fe931de, 0x9b980f5df8606458]),
            l: UInt256([0xa13fc3ef37e7dd8c, 0x0c594aacb3c599e7, 0x4f10ec6e12030f0a, 0xa043c3222a31401c])
        )
        let (hi, lo) = a.multipliedFullWidth(by: b)
        XCTAssertEqual(hi, h)
        XCTAssertEqual(lo, l)
        let (q, r) = b.dividingFullWidth((hi, lo))
        XCTAssertEqual(q, a)
        XCTAssertEqual(r, 0)
    }

    func testMultiplication2() {
        let (a, b, h, l) = (
            a: UInt256([0x51120fdc30a3aef9, 0x42196576fd405f95, 0x19916bda5dc6eb36, 0xe71fb9610ba310f4]),
            b: UInt256([0x313545048badf055, 0x43a80c3305ebbf23, 0xb90f5b7b356e0c65, 0xf623a82a05ff0179]),
            h: UInt256([0x0f9553a1bcafe2db, 0x0579d895e304e480, 0xa3acecd68b9f4dd1, 0xb2e6783ef03a8971]),
            l: UInt256([0x894701e4f948c979, 0xd59366a3f087bd8e, 0x7d15281dd76cbe7b, 0x9fd9aeb4ca2ff754])
        )
        let (hi, lo) = a.multipliedFullWidth(by: b)
        XCTAssertEqual(hi, h)
        XCTAssertEqual(lo, l)
        let (q, r) = b.dividingFullWidth((hi, lo))
        XCTAssertEqual(q, a)
        XCTAssertEqual(r, 0)
    }

    func testMultiplication3() {
        let (a, b, h, l) = (
            a: UInt256([0x9470419cdfc164a1, 0xbc9e6cbe3e2ab1c6, 0x8d384ae1d5a02075, 0xad0bc6cc3f9046a7]),
            b: UInt256([0x8b54f37502956e0d, 0x49d78ea34cecba95, 0xd79e60615c086c72, 0xb2f01eae61e3a8a4]),
            h: UInt256([0x50ca35a01c0cd7d9, 0x0727e823a680f014, 0x63b9be8290d53023, 0x38910b3572b9006e]),
            l: UInt256([0x66afca0af8f12dee, 0xe9578fac42753a68, 0x494078a1170ccdbd, 0xb81b03c553dfdafc])
        )
        let (hi, lo) = a.multipliedFullWidth(by: b)
        XCTAssertEqual(hi, h)
        XCTAssertEqual(lo, l)
        let (q, r) = b.dividingFullWidth((hi, lo))
        XCTAssertEqual(q, a)
        XCTAssertEqual(r, 0)
    }

    func testMultiplication4() {
        let (a, b, h, l) = (
            a: UInt256([0x3a7cde0c848cb429, 0xb3234c0a80547382, 0x55cc7e86e93dabb6, 0x28dee13a766b9aed]),
            b: UInt256([0x000aba3baca1389d, 0xfcc252dc1ce06704, 0x0c388570c1098d9e, 0x86c0c2c073f5d072]),
            h: UInt256([0x0002736d080a2d57, 0x48c8f17d2c12de47, 0x4aaf5ff893c9d9c2, 0x621b6d1ae50ddf46]),
            l: UInt256([0x99c31fb9279e6283, 0xb014a8f3495e108b, 0x8a806df6b06b3976, 0xb6414393e59c8d8a])
        )
        let (hi, lo) = a.multipliedFullWidth(by: b)
        XCTAssertEqual(hi, h)
        XCTAssertEqual(lo, l)
        let (q, r) = b.dividingFullWidth((hi, lo))
        XCTAssertEqual(q, a)
        XCTAssertEqual(r, 0)
    }

    func testMultiplication5() {
        let (a, b, h, l) = (
            a: UInt256([0x6e43798e2e1ef38e, 0x668b891183e734a8, 0xe3ee738dca4300c5, 0x75a15cca018cb882]),
            b: UInt256([0x1f6b6d99eab0309c, 0x1e32d5416109a0c1, 0xd63d07b3d8a50fca, 0x7b83b21df67aeba8]),
            h: UInt256([0x0d8871210c2dc67a, 0x35f57c2854732d99, 0x290f9a543fb59a7c, 0xdb3aec6fd4699086]),
            l: UInt256([0x472cd4b3f13abc51, 0xdc6e808430e2a128, 0xa5dd39777e5d76d3, 0x8d9595140bac6b50])
        )
        let (hi, lo) = a.multipliedFullWidth(by: b)
        XCTAssertEqual(hi, h)
        XCTAssertEqual(lo, l)
        let (q, r) = b.dividingFullWidth((hi, lo))
        XCTAssertEqual(q, a)
        XCTAssertEqual(r, 0)
    }

    func testMultiplication6() {
        let (a, b, h, l) = (
            a: UInt256([0x4e0dea1848328ac1, 0x0b6f50d5416e39de, 0xf2f4c0544ec5bd7b, 0xab8306f4b613e1b0]),
            b: UInt256([0x2e8d5743927b4c81, 0x9789500fcb1af33a, 0xeac4aff5a4b7eeb8, 0x481076e0cf057b89]),
            h: UInt256([0x0e319855a134e52e, 0x2650fa44933aaf7e, 0x22de78bd54e5326d, 0xa8497228b20e6c02]),
            l: UInt256([0x5a1cfb544a711c01, 0xcbf47561f8f1d895, 0x9454efd9063dd009, 0xd5e48851b6835730])
        )
        let (hi, lo) = a.multipliedFullWidth(by: b)
        XCTAssertEqual(hi, h)
        XCTAssertEqual(lo, l)
        let (q, r) = b.dividingFullWidth((hi, lo))
        XCTAssertEqual(q, a)
        XCTAssertEqual(r, 0)
    }

    func testDivisionShifted() {
        let dividend = (high: UInt256(UInt64.max), low: UInt256())
        let divisor =  UInt256(UInt64.max) << 1
        let (q, _) = divisor.dividingFullWidth(dividend)
        XCTAssertEqual(q, UInt256([0x8000000000000000, 0, 0, 0]))
    }
    
    func testDividerWithRemainder() {
        XCTAssertEqual(UInt256(1).dividedReportingOverflow(by: UInt256(0)).overflow, true)
        XCTAssertEqual(UInt256(1).remainderReportingOverflow(dividingBy: UInt256(0)).overflow, true)
        for _ in 1..<10 {
            let a = generateUInt256()
            let b = generateUInt256()
            let (quotient, _) = a.dividedReportingOverflow(by: b)
            let (remainder, _) = a.remainderReportingOverflow(dividingBy: b)
            let (product, _) = quotient.multipliedReportingOverflow(by: b)
            XCTAssertEqual(product + remainder, a)
        }
    }

    func testDividerWithRemainder1() {
        let a = UInt256([0, UInt64.max, 0, 0])
        let b = UInt256(UInt64.max) << 1
        let (quotient, remainder) = UInt256.divisionWithRemainder(a, b)
        XCTAssertEqual(remainder, 0)
        XCTAssertEqual(quotient, UInt256([0, 0, 0x8000000000000000, 0]))
    }

    func testBigIntModulo() {
        let a = UInt256([0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF, 0xFFFFFFFEFFFFFC2F])
        let b = UInt256([0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF, 0xFFFFFFFEFFFFFC2D])
        XCTAssertEqual(a % a, 0)
        XCTAssertEqual(b % a, b)
    }
}
