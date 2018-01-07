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

    private typealias UInt512_t = (high: UInt256, low: UInt256)

    private func shiftedFullWidth(by rhs: Int) -> UInt512_t {
        var high, low: UInt256
        switch rhs {
        case 0..<256:
            high = self >> Int(256 - rhs)
            low = self << rhs
        case 256..<512:
            high = self << (rhs - 256)
            low = 0
        default:
            high = 0
            low = 0
        }
        
        return (high: high, low: low)
    }
    
    private static func fullWidthSubtraction(_ lhs: UInt512_t, _ rhs: UInt512_t) -> (result: UInt512_t, overflow: Bool) {
        var result: UInt512_t, overflow: Bool = false
        var overflowCarry: Bool = false
        var _lhs = lhs, _rhs = rhs

        let (low, overflowL) = _lhs.low.subtractingReportingOverflow(_rhs.low)
        if overflowL {
            (_lhs.high, overflowCarry) = _lhs.high.subtractingReportingOverflow(1)
        }

        let (high, overflowH) = _lhs.high.subtractingReportingOverflow(_rhs.high)
        if overflowCarry || overflowH {
            overflow = true
        }

        result = (high, low)
        return (result, overflow)
    }
    
    private static func greaterThanOrEqualTo(uint512_l lhs: UInt512_t, uint512_r rhs: UInt512_t) -> Bool {
        return lhs.high > rhs.high || (lhs.high == rhs.high && lhs.low >= rhs.low)
    }

    public func dividingFullWidth(_ dividend: (high: UInt256, low: UInt256)) -> (quotient: UInt256, remainder: UInt256) {
        guard dividend.high > 0 || dividend.low > 0 else {
            return (0, 0)
        }
        guard self > 0 else {
            return (0, 0)
        }
        guard self > 1 else {
            // should be the dividend, truncated here
            return (dividend.low, 0)
        }

        var quotient: UInt256 = 0
        var remainder: UInt512_t = (high: dividend.high, low: dividend.low)
        let partial: UInt256 = 1
        let chunk: UInt256 = UInt256(self)
        var currentChunk: UInt512_t = chunk.shiftedFullWidth(by: 0)
        var currentPartial: UInt512_t = partial.shiftedFullWidth(by: 0)
        var trail: [(UInt512_t, UInt512_t)] = [(currentPartial, currentChunk)]
        var shift: Int = 1
        var (nextResult, nextOverflow) = UInt256.fullWidthSubtraction(remainder, currentChunk)

        while UInt256.greaterThanOrEqualTo(uint512_l: nextResult, uint512_r: currentChunk) && !nextOverflow {
            currentChunk = chunk.shiftedFullWidth(by: shift)
            currentPartial = partial.shiftedFullWidth(by: shift)
            shift = shift + 1
            trail.append((currentPartial, currentChunk))
            (nextResult, nextOverflow) = UInt256.fullWidthSubtraction(remainder, currentChunk)
        }

        for (prt, chk) in trail.reversed() {
            if UInt256.greaterThanOrEqualTo(uint512_l: remainder, uint512_r: chk) {
                (remainder, _) = UInt256.fullWidthSubtraction(remainder, chk)
                quotient += prt.low
            }
        }

        return (quotient, remainder.low)
    }
}
