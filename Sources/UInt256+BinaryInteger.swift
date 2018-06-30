//
import Foundation

extension UInt256: BinaryInteger {

    public typealias Words = [UInt]

    public static var isSigned: Bool {
        return false
    }

    public var words: [UInt] {
        get {
            var result = [UInt]()
            for value in parts.reversed() {
                result.append(contentsOf: value.words)
            }
            return result
        }
    }

    public static var bitWidth: Int {
        return 256
    }

    public var bitWidth: Int {
        return UInt256.bitWidth
    }
    
    public var trailingZeroBitCount: Int {
        var result: Int = 0
        for value in parts.reversed() {
            let count = value.trailingZeroBitCount
            if count == 0 {
                return result
            }
            result += count
            if count < 64 {
                return result
            }
        }
        return result
    }

    public init<T>(_ source: T) where T : BinaryFloatingPoint {
        self.init(withUInt64: UInt64(source))
    }

    public init?<T: BinaryInteger>(exactly source: T) {
        if let uint64 = UInt64(exactly: source) {
            self.init(withUInt64: uint64)
        } else {
            return nil
        }
    }
    
    public init<T: BinaryInteger>(clamping source: T) {
        self.init(withUInt64: UInt64(clamping: source))
    }

    public init<T: BinaryInteger>(truncatingIfNeeded source: T) {
        self.init(withUInt64: UInt64(truncatingIfNeeded: source))
    }

    static func leftShift(_ lhs: UInt256, _ rhs: UInt256) -> UInt256 {
        guard rhs < 256 else {
            return UInt256(0)
        }
        let modulus = Int(rhs[3] & 0x00ff)
        let remainder = modulus % 64
        let multiple = (modulus - remainder) / 64

        var result: [UInt64] = []
        for i in multiple..<4 {
            var value: UInt64 = lhs[i] << remainder
            if i < 3 {
                value |= lhs[i + 1] >> (64 - remainder)
            }
            result.append(value)
        }

        for _ in 0..<multiple {
            result.append(0)
        }

        return UInt256(result)
    }

    public static func <<(lhs: UInt256, rhs: Int) -> UInt256 {
        return leftShift(lhs, UInt256(rhs))
    }

    public static func <<<T: BinaryInteger>(lhs: UInt256, rhs: T) -> UInt256 {
        return leftShift(lhs, UInt256(rhs))
    }

    public static func <<=<T: BinaryInteger>(lhs: inout UInt256, rhs: T) {
        lhs = leftShift(lhs, UInt256(rhs))
    }

    public static func <<(lhs: UInt256, rhs: UInt256) -> UInt256 {
        return leftShift(lhs, rhs)
    }

    public static func <<=(lhs: inout UInt256, rhs: UInt256) {
        lhs = lhs << rhs
    }

    static func rightShift(_ lhs: UInt256, _ rhs: UInt256) -> UInt256 {
        guard rhs < 256 else {
            return UInt256(0)
        }
        let modulus = Int(rhs[3] & 0x00ff)
        let remainder = modulus % 64
        let multiple = modulus / 64

        var result: [UInt64] = []
        for _ in 0..<multiple {
            result.append(0)
        }
        for i in 0..<4-multiple {
            var value: UInt64 = lhs[i] >> remainder
            if i > 0 {
                value |= lhs[i - 1] << (64 - remainder)
            }
            result.append(value)
        }

        return UInt256(result)
    }

    public static func >>(lhs: UInt256, rhs: Int) -> UInt256 {
        return rightShift(lhs, UInt256(rhs))
    }

    public static func >><T: BinaryInteger>(lhs: UInt256, rhs: T) -> UInt256 {
        return rightShift(lhs, UInt256(rhs))
    }

    public static func >>=<T: BinaryInteger>(lhs: inout UInt256, rhs: T) {
        lhs = rightShift(lhs, UInt256(rhs))
    }

    public static func >>(lhs: UInt256, rhs: UInt256) -> UInt256 {
        return rightShift(lhs, rhs)
    }

    public static func >>=(lhs: inout UInt256, rhs: UInt256) {
        lhs = lhs >> rhs
    }
    
    public static func &(lhs: UInt256, rhs: UInt256) -> UInt256 {
        return UInt256([
            lhs[0] & rhs[0],
            lhs[1] & rhs[1],
            lhs[2] & rhs[2],
            lhs[3] & rhs[3],
        ])
    }
    
    public static func &=(lhs: inout UInt256, rhs: UInt256) {
        lhs = lhs & rhs
    }
    
    public static func ^(lhs: UInt256, rhs: UInt256) -> UInt256 {
        return UInt256([
            lhs[0] ^ rhs[0],
            lhs[1] ^ rhs[1],
            lhs[2] ^ rhs[2],
            lhs[3] ^ rhs[3],
        ])
    }
    
    public static func ^=(lhs: inout UInt256, rhs: UInt256) {
        lhs = lhs ^ rhs
    }
    
    public static func |(lhs: UInt256, rhs: UInt256) -> UInt256 {
        return UInt256([
            lhs[0] | rhs[0],
            lhs[1] | rhs[1],
            lhs[2] | rhs[2],
            lhs[3] | rhs[3],
        ])
    }
    
    public static func |=(lhs: inout UInt256, rhs: UInt256) {
        lhs = lhs | rhs
    }
    
    public static prefix func ~(lhs: UInt256) -> UInt256 {
        return UInt256([~lhs[0], ~lhs[1], ~lhs[2], ~lhs[3]])
    }
}
