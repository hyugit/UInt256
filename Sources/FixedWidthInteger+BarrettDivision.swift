//

import Foundation

extension FixedWidthInteger {

    public func dividingFullWidth(
        _ dividend: (high: Self, low: Self.Magnitude),
        withPrecomputedInverse inv: (high: Self, low: Self)
        )
        -> (quotient: Self, remainder: Self)
    {
        // the divisor needs to be `normalized` before applying divide and conquer algo
        let count = self.leadingZeroBitCount
        let (q1, r1) = Self.barrettDivision(
            of: dividend,
            by: (self << count),
            withPrecomputedInverse: (
                high: inv.high >> count,
                low: ((inv.low >> count) | (inv.high << (inv.high.bitWidth - count)))
            )
        )
        let (q0, _) = r1.dividedReportingOverflow(by: self)
        let quotient = q1 << count + q0
        let (r0, _) = r1.remainderReportingOverflow(dividingBy: self)
        return (quotient, r0)
    }

    static func barrettDivision(
        of dividend: (high: Self, low: Self.Magnitude),
        by divisor: Self,
        withPrecomputedInverse inv: (high: Self, low: Self)
        )
        -> (quotient: Self, remainder: Self)
    {
        let q1 = dividend.high // ...multiplied by inv.high which == 1
        let q0 = dividend.high.multipliedFullWidth(by: inv.low)
        let q = q1.addingReportingOverflow(q0.high)
        var qb = q.partialValue.multipliedFullWidth(by: divisor)
        if q.overflow {
            qb.high = qb.high + divisor
        }

        let lo: Self = dividend.low as! Self
        var rL = lo.subtractingReportingOverflow(qb.low as! Self)
        var rH = dividend.high.subtractingReportingOverflow(qb.high)
        if rL.overflow {
            rH.partialValue = rH.partialValue - 1
        }

        var quotient = q.partialValue
        while rH.partialValue > 0 || rL.partialValue >= divisor {
            quotient = quotient + 1
            rL = rL.partialValue.subtractingReportingOverflow(divisor)
            if rL.overflow && rH.partialValue > 0 {
                rH.partialValue = rH.partialValue - 1
            }
        }
        return (quotient, rL.partialValue)
    }
}
