//

import Foundation

// MARK: - implementation of karatsuba multiplication
// more details here: https://members.loria.fr/PZimmermann/mca/mca-cup-0.5.9.pdf
//
extension UInt256 {
    private typealias SplitResult = (
        aH: UInt256,
        aL: UInt256,
        bH: UInt256,
        bL: UInt256,
        N2: Int
    )

    /// Karatsuba multiplication of two equal length unsigned integers
    /// karatsuba algorithm is the divide and conquer algorithm for
    /// multiplications.
    /// it reduces a multiplication of length n to 3 multiplications
    /// of length n/2, plus some other operations (-, <<, +).
    /// the result is double of length of the operands at most
    ///
    /// - Parameters:
    ///   - lhs: first operand of the multiplication
    ///   - rhs: second operand of the multiplication
    /// - Returns: (high, low), the full width result of the multiplication
    public static func karatsuba(_ lhs: UInt256, _ rhs: UInt256) -> (high: UInt256, low: UInt256) {

        guard lhs > 0 && rhs > 0 else {
            return (0, 0)
        }

        guard lhs.leadingZeroBitCount < 192 || rhs.leadingZeroBitCount < 192 else {
            let (high: low2, low: low3) = lhs[3].multipliedFullWidth(by: rhs[3])
            return (high: 0, low: UInt256([low2, low3]))
        }

        let (aH, aL, bH, bL, N2) = splitOperands(a: lhs, b: rhs)

        let (_, u) = karatsuba(aH, bH)
        let (_, v) = karatsuba(aL, bL)
        var w = karatsuba(aH + aL, bH + bL)
        var overflow = false

        (w.low, overflow) = w.low.subtractingReportingOverflow(u)
        if overflow {
            w.high = w.high - 1
        }

        (w.low, overflow) = w.low.subtractingReportingOverflow(v)
        if overflow {
            w.high = w.high - 1
        }

        var high: UInt256 = 0
        var low: UInt256 = 0
        var carry: Bool

        switch N2 {
        case 128:
            let wH = UInt256([w.high[2], w.high[3], w.low[0], w.low[1]])
            let wL = UInt256([w.low[2], w.low[3], 0, 0])

            high = u + wH
            (low, carry) = v.addingReportingOverflow(wL)
            if carry {
                high += 1
            }

        default: // N2 == 64
            let uH = UInt256([u[2], u[3], 0, 0])
            let wM = UInt256([w.low[1], w.low[2], w.low[3], 0])
            low = uH + v
            (low, carry) = low.addingReportingOverflow(wM)
        }

        return (high, low)
    }

    private static func splitOperands(a: UInt256, b: UInt256) -> SplitResult {
        let leadingZeroBitCount = Swift.min(
            a.leadingZeroBitCount,
            b.leadingZeroBitCount
        )
        var result: SplitResult

        switch leadingZeroBitCount {
        case 0..<128:
            result = (
                aH: UInt256([0, 0, a[0], a[1]]),
                aL: UInt256([0, 0, a[2], a[3]]),
                bH: UInt256([0, 0, b[0], b[1]]),
                bL: UInt256([0, 0, b[2], b[3]]),
                N2: 128
            )
        case 128..<192:
            result = (
                aH: UInt256(a[2]),
                aL: UInt256(a[3]),
                bH: UInt256(b[2]),
                bL: UInt256(b[3]),
                N2: 64
            )
        default:
            // Range is cool, but switch doesn't recognize open
            // ranges, such as (192...) or (..<128), hence this
            // `default` case
            result = (0, a, 0, b, 64)
        }
        
        return result
    }
}
