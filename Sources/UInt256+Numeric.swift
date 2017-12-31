//
// Created by MrYu87 on 12/29/17.
// Copyright (c) 2017 MrYu87. All rights reserved.
//

import Foundation

extension UInt256: Numeric {

    static func getAdderCarry(value: UInt64, lhs: UInt64, rhs: UInt64, carry: UInt64) -> UInt64 {
        if lhs == 0 && rhs == 0 && carry == 0 {
            return 0
        }
        let a = value <= lhs
        let b = value <= rhs
        let c = value <= carry

        if a && b || b && c || a && c {
            return 1
        }

        return 0
    }

    static func add(_ lhs: UInt256, _ rhs: UInt256) -> (UInt256, Bool) {
        var values = [UInt64]()
        var carry: UInt64 = 0
        let range = 0..<4
        for i in range.reversed() {
            values.insert(lhs[i] &+ rhs[i] &+ carry, at: 0)
            carry = getAdderCarry(
                value: values[0],
                lhs: lhs[i],
                rhs: rhs[i],
                carry: carry
            )
        }

        let result = UInt256(values)
        let overflow = carry == 1
        return (result, overflow)
    }

    public static func &+(lhs: UInt256, rhs: UInt256) -> UInt256 {
        let (result, _) = add(lhs, rhs)
        return result
    }

    public static func +(lhs: UInt256, rhs: UInt256) -> UInt256 {
        let (result, _) = add(lhs, rhs)
        return result
    }

    public static func +=(_ lhs: inout UInt256, _ rhs: UInt256) {
//        lhs = try lhs + rhs
        lhs = lhs + rhs
    }

    static func subtract(_ lhs: UInt256, _ rhs: UInt256) -> (UInt256, Bool) {
        var values = [UInt64]()
        var carry: UInt64 = 0
        let range = 0..<4
        for i in range.reversed() {
            values.insert(lhs[i] &- rhs[i] &- carry, at: 0)
            carry = getAdderCarry(value: lhs[i], lhs: values[0], rhs: rhs[i], carry: carry)
        }

        let result = UInt256(values)
        let overflow = carry == 1
        return (result, overflow)
    }

    public static func &-(_ lhs: UInt256, _ rhs: UInt256) -> UInt256 {
        let (result, _) = subtract(lhs, rhs)
        return result
    }

    public static func -(_ lhs: UInt256, _ rhs: UInt256) -> UInt256 {
        let (result, _) = subtract(lhs, rhs)
        return result
    }

    public static func -=(_ lhs: inout UInt256, _ rhs: UInt256) {
        lhs = lhs - rhs
    }

    static func multiply(_ lhs: UInt256, byUInt64 rhs: UInt64) -> UInt256 {
        if lhs == 0 || rhs == 0 {
            return 0
        }

        var result: UInt256 = 0
        for i in 0..<rhs.bitWidth {
            if (rhs >> i) & 0b1 == 1 {
                result += lhs << i
            }
        }

        return result
    }
    
    static func multiply(_ lhs: UInt256, _ rhs: UInt256) -> UInt256 {
        var result: UInt256 = 0
        for i in 0..<4 {
            result += multiply(lhs << (64 * (3 - i)), byUInt64: rhs[i])
        }
        return result
    }
    
    public static func *(_ lhs: UInt256, _ rhs: UInt256) -> UInt256 {
        return multiply(lhs, rhs)
    }

    public static func *=(_ lhs: inout UInt256, _ rhs: UInt256) {
        lhs = lhs * rhs
    }
    
    public static func /(_ lhs: UInt256, _ rhs: UInt256) -> UInt256 {
        return UInt256(1)
    }
    
    public static func /=(_ lhs: inout UInt256, _ rhs: UInt256) {
        lhs = lhs / rhs
    }
    
    public static func modulo(_ lhs: UInt256, _ rhs: UInt256) -> UInt256 {
        if lhs == 0 || rhs == 0 {
            return 0
        }
        if rhs == 1 {
            return 0
        }

        var result: UInt256 = lhs
        while result > rhs {
            var tmp: UInt256 = rhs
            while result - tmp > tmp {
                tmp = tmp << 1
            }
            result -= tmp
        }

        return result
    }

    public static func %(_ lhs: UInt256, _ rhs: UInt256) -> UInt256 {
        return modulo(lhs, rhs)
    }
    
    public static func %=(lhs: inout UInt256, rhs: UInt256) {
        lhs = lhs % rhs
    }
}
