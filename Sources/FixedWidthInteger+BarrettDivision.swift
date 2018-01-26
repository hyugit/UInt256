//

import Foundation

public protocol FixedWidthIntegerBarrettDivisionDelegate {
    var precomputedInverse: (high: Any, low: Any) { get }
}

public protocol FixedWidthIntegerWithBarrettDivision: FixedWidthInteger {
    func dividingFullWidthBarrett(_ dividend: (high: Self, low: Self)) -> (quotient: Self, remainder: Self)
    func dividingFullWidth(_ dividend: (high: Self, low: Self), withPrecomputedInverse: (high: Self, low: Self)) -> (quotient: Self, remainder: Self)
}

extension FixedWidthInteger {
    public var delegate: FixedWidthIntegerBarrettDivisionDelegate? {
        get {
            return nil
        }

        set {}
    }

    public func dividingFullWidthBarrett(_ dividend: (high: Self, low: Self)) -> (quotient: Self, remainder: Self) {
        if let high = self.delegate?.precomputedInverse.high as? Self,
            let low = self.delegate?.precomputedInverse.low as? Self
        {
            return self.dividingFullWidth(dividend, withPrecomputedInverse: (high, low))
        } else {
            return self.dividingFullWidth((dividend.high, dividend.low.magnitude))
        }
    }

    public func dividingFullWidth(_ dividend: (high: Self, low: Self), withPrecomputedInverse: (high: Self, low: Self)) -> (quotient: Self, remainder: Self) {
        return self.dividingFullWidth((dividend.high, dividend.low.magnitude))
    }
}
