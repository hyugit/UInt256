import Foundation

extension UInt256: FixedWidthInteger {

    public init(_truncatingBits: UInt) {
        var result: [UInt64] = []
        for i in 0..<4 {
            let bits = _truncatingBits >> (i * 64)
            result.append(UInt64(_truncatingBits: bits))
        }
        self.init(withUInt64Array: result.reversed())
    }

    public var nonzeroBitCount: Int {
        return parts[0].nonzeroBitCount
            + parts[1].nonzeroBitCount
            + parts[2].nonzeroBitCount
            + parts[3].nonzeroBitCount
    }

    public var leadingZeroBitCount: Int {
        var result: Int = 0
        for value in parts {
            let count = value.leadingZeroBitCount
            if count == 0 {
                return result
            }
            result += count
            if count < 64 {
                return result
            }
        }
        return result
    }

    public var byteSwapped: UInt256 {
        return UInt256([
            parts[3].byteSwapped,
            parts[2].byteSwapped,
            parts[1].byteSwapped,
            parts[0].byteSwapped,
        ])
    }

    public func addingReportingOverflow(_ rhs: UInt256) -> (partialValue: UInt256, overflow: Bool) {
        return UInt256.add(self, rhs)
    }

    public func subtractingReportingOverflow(_ rhs: UInt256) -> (partialValue: UInt256, overflow: Bool) {
        return UInt256.subtract(self, rhs)
    }

    public func multipliedReportingOverflow(by rhs: UInt256) -> (partialValue: UInt256, overflow: Bool) {
        let (high, low) = UInt256.karatsuba(self, rhs)
        if high > 0 {
            return (low, true)
        }
        return (low, false)
    }

    public func dividedReportingOverflow(by rhs: UInt256) -> (partialValue: UInt256, overflow: Bool) {
        guard rhs > 0 else {
            return (UInt256(self), true)
        }
        let (result, _) = UInt256.divisionWithRemainder(self, rhs)
        return (result, false)
    }

    public func remainderReportingOverflow(dividingBy rhs: UInt256) -> (partialValue: UInt256, overflow: Bool) {
        guard rhs > 0 else {
            return (UInt256(self), true)
        }
        let (_, result) = UInt256.divisionWithRemainder(self, rhs)
        return (result, false)
    }

    public func multipliedFullWidth(by other: UInt256) -> (high: UInt256, low: UInt256) {
        return UInt256.karatsuba(self, other)
    }

    public func dividingFullWidth(_ dividend: (high: UInt256, low: UInt256)) -> (quotient: UInt256, remainder: UInt256) {
        // the divisor needs to be `normalized` before applying divide and conquer algo
        let count = self.leadingZeroBitCount
        let (q1, r1) = UInt256.divideAndConquer(dividend, by: (self << count))
        let (q0, r0) = UInt256.divisionWithRemainder(r1, self)
        let quotient = q1 << count + q0
        return (quotient, r0)
    }

    public func dividingFullWidth(
        _ dividend: (high: UInt256, low: UInt256),
        withPrecomputedInverse inv: (high: UInt256, low: UInt256)
        )
        -> (quotient: UInt256, remainder: UInt256)
    {
        // the divisor needs to be `normalized` before applying divide and conquer algo
        let count = self.leadingZeroBitCount
        let (q1, r1) = UInt256.barrettDivision(
            of: dividend,
            by: (self << count),
            withPrecomputedInverse: (
                high: inv.high >> count,
                low: ((inv.low >> count) | (inv.high << (inv.high.bitWidth - count)))
            )
        )
        let (q0, r0) = UInt256.divisionWithRemainder(r1, self)
        let quotient = q1 << count + q0
        return (quotient, r0)
    }
}
