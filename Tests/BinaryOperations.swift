//
//  UInt256Tests+BinaryOperations.swift
//  UInt256Tests
//
//  Created by MrYu87 on 12/30/17.
//  Copyright © 2017 MrYu87. All rights reserved.
//

import XCTest
@testable import UInt256

class UInt256BinaryOperationsTests: XCTestCase {

    func testBinaryProperties() {
        XCTAssertEqual(UInt256.isSigned, false)

        let a: UInt256 = 0
        XCTAssertEqual(a.bitWidth, 256)
        XCTAssertEqual(a.nonzeroBitCount, 0)
        XCTAssertEqual(a.trailingZeroBitCount, 256)
        XCTAssertEqual(a.leadingZeroBitCount, 256)
        XCTAssertEqual(a.byteSwapped, 0)

        // TODO: check the correctness of this test
        XCTAssertEqual(a.words, [0, 0, 0, 0])

        let b = UInt256([
            0x8000000000000000,
            0x0000000000000000,
            0x0000000000000000,
            0x0000000000000000
        ])
        
        XCTAssertEqual(b.bitWidth, 256)
        XCTAssertEqual(b.nonzeroBitCount, 1)
        XCTAssertEqual(b.trailingZeroBitCount, 255)
        XCTAssertEqual(b.leadingZeroBitCount, 0)
        XCTAssertEqual(b.byteSwapped, UInt256([0, 0, 0, 0x80]))

        // TODO: check the correctness of this test
        XCTAssertEqual(b.words, [0, 0, 0, 0x8000000000000000])

        let c = UInt256([
            0x0000000100000000,
            0x0000000100000000,
            0x0000000100000000,
            0x0000000100000000
        ])
        XCTAssertEqual(c.bitWidth, 256)
        XCTAssertEqual(c.nonzeroBitCount, 4)
        XCTAssertEqual(c.trailingZeroBitCount, 32)
        XCTAssertEqual(c.leadingZeroBitCount, 31)
        XCTAssertEqual(c.byteSwapped, UInt256([
            0x1000000,
            0x1000000,
            0x1000000,
            0x1000000
        ]))
        // TODO: check the correctness of this test
        XCTAssertEqual(c.words, [
            0x100000000,
            0x100000000,
            0x100000000,
            0x100000000,
        ])

        let d = UInt256([0, 0, 1, 0])
        XCTAssertEqual(d.bitWidth, 256)
        XCTAssertEqual(d.nonzeroBitCount, 1)
        XCTAssertEqual(d.trailingZeroBitCount, 64)
        XCTAssertEqual(d.leadingZeroBitCount, 191)

        // TODO: check the correctness of this test
        XCTAssertEqual(d.words, [0, 1, 0, 0])
    }

    func testShift() {
        let a = UInt256([0, 0xffffffffffffffff, 0, 0xffffffffffffffff])
        let b = a << UInt256(0xffffffff00000000 as UInt64)
        XCTAssertEqual(b, UInt256([
            0,
            0,
            0,
            0
        ]))

        let b0 = a << 200
        XCTAssertEqual(b0, UInt256([
            0xffffffffffffff00,
            0x0,
            0,
            0
        ]))
        XCTAssertEqual(a >> b0, UInt256.min)

        var b1 = a
        b1 <<= 4
        let b2 = a << (4 as UInt)
        let b3 = a << (4 as Int)
        var b4 = a
        b4 <<= (4 as UInt)
        XCTAssertEqual(b1, UInt256([
            0xf,
            0xfffffffffffffff0,
            0xf,
            0xfffffffffffffff0
        ]))
        XCTAssertEqual(b1, b2)
        XCTAssertEqual(b2, b3)
        XCTAssertEqual(b3, b4)

        var c0 = a
        c0 >>= 130
        let c1 = a >> (8 as UInt)
        var c2 = a
        c2 >>= (130 as UInt)
        let c3 = a >> (130 as Int)
        XCTAssertEqual(c0, UInt256([
            0,
            0,
            0,
            0x3fffffffffffffff
        ]))
        XCTAssertEqual(c1, UInt256([
            0,
            0x00ffffffffffffff,
            0xff00000000000000,
            0x00ffffffffffffff
        ]))
        XCTAssertEqual(c0, c2)
        XCTAssertEqual(c3, c2)
    }
    
    func testShift1() {
        let d = UInt256([
            0x2222222222222222,
            0x3333333333333333,
            0x4444444444444444,
            0x5555555555555555
        ])
        let e = d >> 1
        let f = d << 1
        XCTAssertEqual(e, UInt256([
            0x1111111111111111,
            0x1999999999999999,
            0xa222222222222222,
            0x2aaaaaaaaaaaaaaa
        ]))
        XCTAssertEqual(f, UInt256([
            0x4444444444444444,
            0x6666666666666666,
            0x8888888888888888,
            0xaaaaaaaaaaaaaaaa
        ]))
    }
    
    func testLogicOperations() {
        let a = UInt256([
            0x5555555555555555,
            0x5555555555555555,
            0x5555555555555555,
            0x5555555555555555,
        ])
        let b = UInt256([
            0xaaaaaaaaaaaaaaaa,
            0xaaaaaaaaaaaaaaaa,
            0xaaaaaaaaaaaaaaaa,
            0xaaaaaaaaaaaaaaaa,
        ])
        XCTAssertEqual(a & b, UInt256.min)
        XCTAssertEqual(a | b, UInt256.max)
        XCTAssertEqual(a ^ a, UInt256.min)
        XCTAssertEqual(a ^ b, UInt256.max)
        XCTAssertEqual(~a, b)
        var c = a
        c &= b
        XCTAssertEqual(c, UInt256.min)
        c |= a
        XCTAssertEqual(c, a)
        c ^= b
        XCTAssertEqual(c, UInt256.max)
    }
}
