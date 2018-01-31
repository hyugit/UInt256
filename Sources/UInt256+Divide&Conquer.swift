//

import Foundation

extension UInt256 {

    /// Divide and conquer algorithm for division
    /// Top level algo. It uses two subroutines:
    /// divideAndConquer2By1 and divideAndConquer3By2
    ///
    /// - Parameters:
    ///   - dividend: (high: UInt256, low: UInt256)
    ///   - divisor: UInt256
    /// - Returns: (quotient: UInt256, remainder: UInt256)
    static func divideAndConquer(_ dividend: (high: UInt256, low: UInt256), by divisor: UInt256) -> (quotient: UInt256, remainder: UInt256) {
        var (hi, lo) = dividend
        guard hi > 0 else {
            return divisionWithRemainder(dividend.low, divisor)
        }

        if hi > divisor { // throw away the overflown part
            hi = hi % divisor
        }

        return divideAndConquer2By1((hi, lo), by: divisor)
    }

    /// Divide And Conquer 2 By 1
    /// this algorithm is in charge of handling 2-by-1 scenarios.
    /// the algorithm divide the high and low components into two
    /// 3-by-2 divisions and pass them over to 3-by-2 algorithm
    /// to calculate
    ///
    /// - Parameters:
    ///   - dividend: (high: UInt256, low: UInt256)
    ///   - divisor: UInt256
    /// - Returns: (quotient: UInt256, remainder: UInt256)
    static func divideAndConquer2By1(_ dividend: (high: UInt256, low: UInt256), by divisor: UInt256) -> (quotient: UInt256, remainder: UInt256) {
        let (hi, lo) = dividend

        guard hi > 0 else {
            return divisionWithRemainder(dividend.low, divisor)
        }

        let highDividend = (high: UInt256([0, 0, hi[0], hi[1]]), low: UInt256([hi[2], hi[3], lo[0], lo[1]]))
        let (q1, r1) = divideAndConquer3By2(highDividend, by: divisor)

        let lowDividend = (high: UInt256([0, 0, r1[0], r1[1]]), low: UInt256([r1[2], r1[3], lo[2], lo[3]]))
        let (q0, r0) = divideAndConquer3By2(lowDividend, by: divisor)

        let quotient = UInt256([q1[2], q1[3], 0, 0]) + q0
        let remainder = r0

        return (quotient, remainder)
    }

    /// Divide And Conquer 3 By 2
    /// This algorithm takes a 3-by-2 division and calculates the results
    /// 3-by-2 here means it's 384-by-256, i.e. 128 most significant bits
    /// of dividend.high are zeros (dividend.high.leadingZeroCount >= 128)
    ///
    /// - Parameters:
    ///   - dividend: (high: UInt256, low: UInt256)
    ///   - divisor: UInt256
    /// - Returns: (quotient: UInt256, remainder: UInt256)
    static func divideAndConquer3By2(_ dividend: (high: UInt256, low: UInt256), by divisor: UInt256) -> (quotient: UInt256, remainder: UInt256) {
        let (hi, lo) = dividend

        guard hi > 0 else {
            return divisionWithRemainder(dividend.low, divisor)
        }

        var q_: UInt256 = 0
        var r1: UInt256 = 0
        let b1 = UInt256([0, 0, divisor[0], divisor[1]])
        if hi < b1 {
            let highDividend = UInt256([hi[2], hi[3], lo[0], lo[1]])
            (q_, r1) = divisionWithRemainder(highDividend, b1)
        } else {
            q_ = UInt256([0, 0, UInt64.max, UInt64.max])
            let diff = hi - b1
            r1 = UInt256([diff[2], diff[3], lo[0], lo[1]]) + b1
        }

        let overflow = r1[1] > 0
        let lowDividend = UInt256([r1[2], r1[3], lo[2], lo[3]])
        let b0 = UInt256([0, 0, divisor[2], divisor[3]])
        var (remainder, subOverflow) = lowDividend.subtractingReportingOverflow(q_ * b0)
        var quotient = q_
        if !overflow && subOverflow {
            let addOverflow: Bool
            quotient = quotient - 1
            (remainder, addOverflow) = remainder.addingReportingOverflow(divisor)
            if !addOverflow {
                quotient = quotient - 1
                remainder = remainder + divisor
            }
        }

        return (quotient, remainder)
    }
}
