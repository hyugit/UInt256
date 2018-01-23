//

import Foundation

public protocol FixedWidthIntegerWithBarrettDivision: FixedWidthInteger {
    func dividingFullWidthFast(_ dividend: (high: Self, low: Self), withPrecomputedInverse: (high: Self, low: Self)) -> (quotient: Self, remainder: Self)
}
