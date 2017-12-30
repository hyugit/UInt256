//
//  UInt256Tests+BinaryOperations.swift
//  UInt256Tests
//
//  Created by MrYu87 on 12/30/17.
//  Copyright © 2017 MrYu87. All rights reserved.
//

import XCTest

class UInt256BinaryOperationsTests: XCTestCase {

    func testBinaryProperties() {
        let a: UInt256 = 0
        XCTAssertEqual(a.bitWidth, 256)
        XCTAssertEqual(a.trailingZeroBitCount, 256)

        let b = UInt256([
            0x8000000000000000,
            0x0000000000000000,
            0x0000000000000000,
            0x0000000000000000
        ])
        XCTAssertEqual(b.bitWidth, 256)
        XCTAssertEqual(b.trailingZeroBitCount, 255)

        let c = UInt256([
            0x8000000000000000,
            0x0000000000000000,
            0x0000000100000000,
            0x0000000100000000
        ])
        XCTAssertEqual(c.bitWidth, 256)
        XCTAssertEqual(c.trailingZeroBitCount, 32)
    }

    func testShift() {
        let a = UInt256([0, 0xffffffffffffffff, 0, 0xffffffffffffffff])
        let b = a << UInt256(0xffffffff00000000 as UInt64)
        let b0 = a << 200
        let b1 = a << 4
        let c0 = a >> 130
        let c1 = a >> 8
        XCTAssertEqual(b, UInt256([
            0,
            0,
            0,
            0
        ]))
        XCTAssertEqual(b0, UInt256([
            0xffffffffffffff00,
            0x0,
            0,
            0
        ]))
        XCTAssertEqual(b1, UInt256([
            0xf,
            0xfffffffffffffff0,
            0xf,
            0xfffffffffffffff0
        ]))
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
    }
}
