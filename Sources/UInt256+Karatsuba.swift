//

import Foundation

extension UInt256 {
    private typealias SplitResult = (
        a_h: UInt256,
        a_l: UInt256,
        b_h: UInt256,
        b_l: UInt256,
        n_2: Int
    )

    public static func karatsuba(_ lhs: UInt256, _ rhs: UInt256) -> (high: UInt256, low: UInt256) {

        if lhs.leadingZeroBitCount >= 192 && rhs.leadingZeroBitCount >= 192 {
            let (high: low2, low: low3) = lhs[3].multipliedFullWidth(by: rhs[3])
            return (high: 0, low: UInt256([low2, low3]))
        }

        let (a_h, a_l, b_h, b_l, n_2) = splitOperands(a: lhs, b: rhs)

        let (_, u) = karatsuba(a_h, b_h)
        let (_, v) = karatsuba(a_l, b_l)
        let (part_over, part_w) = karatsuba(a_h + a_l, b_h + b_l)

        let (w_u, subtractionOverflow_u) = part_w.subtractingReportingOverflow(u)
        let overflow_w_u: UInt256
        if subtractionOverflow_u {
            overflow_w_u = part_over - 1
        } else {
            overflow_w_u = part_over
        }

        let (w, subtractionOverflow) = w_u.subtractingReportingOverflow(v)
        let overflow_w: UInt256
        if subtractionOverflow {
            overflow_w = overflow_w_u - 1
        } else {
            overflow_w = overflow_w_u
        }

        var high: UInt256 = 0
        var low: UInt256 = 0
        var carry: Bool

        switch n_2 {
        case 128:
            let w_h = UInt256([overflow_w[2], overflow_w[3], w[0], w[1]])
            let w_l = UInt256([w[2], w[3], 0, 0])

            high = u + w_h
            (low, carry) = v.addingReportingOverflow(w_l)

            if carry {
                high += 1
            }

        default: // n_2 == 64
            let u_h = UInt256([u[2], u[3], 0, 0])
            let w_m = UInt256([w[1], w[2], w[3], 0])
            low = u_h + v
            (low, carry) = low.addingReportingOverflow(w_m)
        }

        return (high: high, low: low)
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
                a_h: UInt256([0, 0, a[0], a[1]]),
                a_l: UInt256([0, 0, a[2], a[3]]),
                b_h: UInt256([0, 0, b[0], b[1]]),
                b_l: UInt256([0, 0, b[2], b[3]]),
                n_2: 128
            )
        case 128..<192:
            result = (
                a_h: UInt256(a[2]),
                a_l: UInt256(a[3]),
                b_h: UInt256(b[2]),
                b_l: UInt256(b[3]),
                n_2: 64
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
