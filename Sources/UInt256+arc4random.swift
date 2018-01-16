//

import Foundation

public func arc4random_uniform(_ upperBound: UInt8) -> UInt8 {
    let result = arc4random_uniform(UInt32(upperBound))
    return UInt8(truncatingIfNeeded: result)
}

public func arc4random_uniform(_ upperBound: UInt16) -> UInt16 {
    let result = arc4random_uniform(UInt32(upperBound))
    return UInt16(truncatingIfNeeded: result)
}

public func arc4random_uniform(_ upperBound: UInt64) -> UInt64 {
    let upperBoundHigh = UInt32(truncatingIfNeeded: (upperBound >> 32))

    if upperBoundHigh == 0 {
        let lowerHalf = UInt32(truncatingIfNeeded: upperBound)
        return UInt64(arc4random_uniform(lowerHalf))
    }

    func generateRandom(within highBits: UInt32) -> UInt64 {
        let high: UInt32 = arc4random_uniform(highBits + 1)
        let low: UInt32 = arc4random_uniform(UInt32.max)
        let result: UInt64 = UInt64(high) << 32 + UInt64(low)
        return result
    }

    var result = generateRandom(within: upperBoundHigh)
    while result >= upperBound {
        result = generateRandom(within: upperBoundHigh)
    }

    return result
}

public func arc4random_uniform(_ upperBound: UInt256) -> UInt256 {
    let zeroPartCount = upperBound.leadingZeroBitCount / 64
    let upperBoundHigh = upperBound[zeroPartCount]

    func generateRandom(within highBits: UInt64) -> UInt256 {
        var parts = Array(repeating: UInt64.min, count: zeroPartCount)
        parts.append(arc4random_uniform(highBits + 1))

        while parts.count < 4 {
            parts.append(arc4random64())
        }
        return UInt256(parts)
    }

    var result = generateRandom(within: upperBoundHigh)
    while result >= upperBound {
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
