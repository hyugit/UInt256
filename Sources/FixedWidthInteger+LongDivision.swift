//

import Foundation

extension FixedWidthInteger {
    public func dividingLong(dividend: [Self]) -> (quotient: [Self], remainder: Self) {
        guard dividend.count > 0 else {
            return ([], 0)
        }

        if dividend.count == 1 {
            return ([dividend[0] / self], dividend[0] % self)
        } else if dividend.count == 2 {
            let (q, r) = self.dividingFullWidth((high: dividend[0], low: dividend[1].magnitude))
            return ([q], r)
        }

        var result = [Self]()
        var remainder: Self = 0
        var quotient: Self = 0
        for element in dividend {
            (quotient, remainder) = self.dividingFullWidth((remainder, element.magnitude))
            result.append(quotient)
        }

        while result[0] == 0 && result.count > 1 {
            result.remove(at: 0)
        }

        return (result, remainder)
    }

    public func multipliedLong(by multiplier: [Self]) -> [Self] {
        guard multiplier.count > 0 else {
            return []
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

        while result[0] == 0 && result.count > 1 {
            result.remove(at: 0)
        }

        return result
    }
}
