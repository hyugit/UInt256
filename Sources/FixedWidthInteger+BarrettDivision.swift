//

import Foundation

extension FixedWidthInteger {
    public func dividingFullWidth(_ dividend: (high: Self, low: Self.Magnitude), withPrecomputedInverse: (high: Self, low: Self)) -> (quotient: Self, remainder: Self) {
        return self.dividingFullWidth(dividend)
    }
}
