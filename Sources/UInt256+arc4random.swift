//

import Foundation

public func arc4random_uniform<T>(_ upperBound: T) -> T where T: FixedWidthInteger & UnsignedInteger {
    if upperBound == 0 {
        return T.min
    }
    if upperBound.bitWidth <= 64 {
        let result = arc4random_uniform64(UInt64(truncatingIfNeeded: upperBound))
        return T(truncatingIfNeeded: result)
    }

    // for the sake of this library, treat it as UInt256
    let result: UInt256 = arc4random_uniform256(upperBound as! UInt256)
    return result as! T
}

func arc4random_uniform64(_ upperBound: UInt64) -> UInt64 {
    guard upperBound > 0 else {
        return 0
    }

    let upperBoundHigh = UInt32(truncatingIfNeeded: (upperBound >> 32))

    guard upperBoundHigh > 0 else {
        let lowerHalf = UInt32(truncatingIfNeeded: upperBound)
        return UInt64(arc4random_uniform(lowerHalf))
    }

    func generateRandom(within highBits: UInt32) -> UInt64 {
        let high: UInt32 = arc4random_uniform(highBits)
        let low: UInt32 = arc4random()
        let result: UInt64 = UInt64(high) << 32 + UInt64(low)
        return result
    }

    var result = generateRandom(within: upperBoundHigh)
    while result >= upperBound {
        result = generateRandom(within: upperBoundHigh)
    }

    return result
}

func arc4random_uniform256(_ upperBound: UInt256) -> UInt256 {
    var result: UInt256
    switch upperBound.leadingZeroBitCount {
    case 0..<64:
        result = UInt256([arc4random_uniform64(upperBound[0]), arc4random64(), arc4random64(), arc4random64()])
    case 64..<128:
        result = UInt256([0, arc4random_uniform64(upperBound[1]), arc4random64(), arc4random64()])
    case 128..<192:
        result = UInt256([0, 0, arc4random_uniform64(upperBound[2]), arc4random64()])
    default:
        result = UInt256([0, 0, 0, arc4random_uniform64(upperBound[3])])
    }
    while result >= upperBound {
        result = arc4random_uniform256(upperBound)
    }

    return result
}

func arc4random64() -> UInt64 {
    let high: UInt32 = arc4random()
    let low: UInt32 = arc4random()
    let result: UInt64 = UInt64(high) << 32 + UInt64(low)
    return result
}

func arc4random256() -> UInt256 {
    return UInt256([arc4random64(), arc4random64(), arc4random64(), arc4random64()])
}
