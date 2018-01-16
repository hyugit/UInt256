//

import Foundation

public func arc4random_uniform(_ upperBound: UInt64) -> UInt64 {
    let upperBoundHigh = UInt32(truncatingIfNeeded: (upperBound >> 32))

    func generateRandom(within highBits: UInt32) -> UInt64 {
        let high: UInt32 = arc4random_uniform(highBits + 1)
        let low: UInt32 = arc4random_uniform(UInt32.max)
        let result: UInt64 = UInt64(high) << 32 + UInt64(low)
        return result
    }

    var result = generateRandom(within: upperBoundHigh)
    while result > upperBound {
        result = generateRandom(within: upperBoundHigh)
    }

    return result
}

public func arc4random64() -> UInt64 {
    let high: UInt32 = arc4random()
    let low: UInt32 = arc4random()
    let result: UInt64 = UInt64(high) << 32 + UInt64(low)
    return result
}

public func arc4random256() -> UInt256 {
    return UInt256([arc4random64(), arc4random64(), arc4random64(), arc4random64()])
}
