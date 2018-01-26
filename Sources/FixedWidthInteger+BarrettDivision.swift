//

import Foundation

extension FixedWidthInteger {
    func dividingFullWidth(_ dividend: (high: Self, low: Self), withPrecomputedInverse inv: (high: Self, low: Self)? = nil) -> (quotient: Self, remainder: Self) {
        guard inv != nil else {
            return self.dividingFullWidth(dividend)
        }
        return self.dividingFullWidth(dividend, withPrecomputedInverse: inv)
    }
}
