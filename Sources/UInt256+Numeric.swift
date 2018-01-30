//

import Foundation

// MARK: - Conforming to Numeric protocol
// details on Numeric protocol:
// https://developer.apple.com/documentation/swift/numeric
extension UInt256: Numeric {

    static func add(_ lhs: UInt256, _ rhs: UInt256) -> (UInt256, Bool) {
        var values = [UInt64]()
        var carry: UInt64 = 0
        for i in (0..<4).reversed() {
            let (result1, overflow1) = lhs[i].addingReportingOverflow(rhs[i])
            let (result2, overflow2) = result1.addingReportingOverflow(carry)
            values.insert(result2, at: 0)
            if overflow1 || overflow2 {
                carry = 1
            } else {
                carry = 0
            }
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
        lhs = lhs + rhs
    }

    static func subtract(_ lhs: UInt256, _ rhs: UInt256) -> (UInt256, Bool) {
        var values = [UInt64]()
        var carry: UInt64 = 0
        for i in (0..<4).reversed() {
            let (result1, overflow1) = lhs[i].subtractingReportingOverflow(rhs[i])
            let (result2, overflow2) = result1.subtractingReportingOverflow(carry)
            values.insert(result2, at: 0)
            if overflow1 || overflow2 {
                carry = 1
            } else {
                carry = 0
            }
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

    public static func *(_ lhs: UInt256, _ rhs: UInt256) -> UInt256 {
        let (_, result) = karatsuba(lhs, rhs)
        return result
    }

    public static func *=(_ lhs: inout UInt256, _ rhs: UInt256) {
        lhs = lhs * rhs
    }

    public static func /(_ lhs: UInt256, _ rhs: UInt256) -> UInt256 {
        let (result, _) = divisionWithRemainder(lhs, rhs)
        return result
    }

    public static func /=(_ lhs: inout UInt256, _ rhs: UInt256) {
        lhs = lhs / rhs
    }

    public static func divisionWithRemainder(_ lhs: UInt256, _ rhs: UInt256) -> (UInt256, UInt256) {
        guard lhs > 0 && rhs > 1 else {
            return (0, 0)
        }

        guard lhs >= rhs else {
            return (0, lhs)
        }

        var quotient: UInt256 = 0
        var remainder: UInt256 = lhs
        var partial: UInt256 = 1
        var chunk: UInt256 = rhs
        var trail: [(UInt256, UInt256)] = [(1, rhs)]

        while remainder - chunk >= chunk {
            chunk = chunk << 1
            partial = partial << 1
            trail.append((partial, chunk))
        }

        for (partial, chunk) in trail.reversed() {
            if remainder >= chunk {
                remainder -= chunk
                quotient += partial
            }
        }

        return (quotient, remainder)
    }

    public static func %(_ lhs: UInt256, _ rhs: UInt256) -> UInt256 {
        let (_, result) = divisionWithRemainder(lhs, rhs)
        return result
    }
    
    public static func %=(lhs: inout UInt256, rhs: UInt256) {
        lhs = lhs % rhs
    }
}
