//

import Foundation

extension FixedWidthInteger {
    public func dividingLong(dividend: [Self]) -> (quotient: [Self], remainder: Self) {
        guard dividend.count > 0 else {
            return ([], 0)
        }

        // simplify logic when length is limited
        if dividend.count == 1 {
            return ([dividend[0] / self], dividend[0] % self)
        }

        var result = [Self]()
        var remainder: Self = 0
        var quotient: Self = 0
        for element in dividend {
            (quotient, remainder) = self.dividingFullWidth((remainder, element.magnitude))
            result.append(quotient)
        }

        // remove the leading zeros, but leave one if last one
        while result[0] == 0 && result.count > 1 {
            result.remove(at: 0)
        }

        return (result, remainder)
    }

    public func multiplyingLong(multiplier: [Self]) -> [Self] {
        guard multiplier.count > 0 else {
            return []
        }

        // simplify logic when length is limited
        if multiplier.count == 1 {
            let (h, l) = self.multipliedFullWidth(by: multiplier[0])
            var result: [Self] = [l as! Self]
            if h > 0 {
                result.insert(h, at: 0)
            }
            return result
        }

        var result: [Self] = [0]
        for element in multiplier.reversed() {
            let multiplied = self.multipliedFullWidth(by: element)
            var overflow = false
            (result[0], overflow) = result[0].addingReportingOverflow(multiplied.low as! Self)
            if overflow {
                result.insert(1, at: 0)
            } else {
                result.insert(0, at: 0)
            }
            (result[0], _) = result[0].addingReportingOverflow(multiplied.high)
        }

        // remove the leading zeros, but leave one if last one
        while result[0] == 0 && result.count > 1 {
            result.remove(at: 0)
        }

        return result
    }
}
