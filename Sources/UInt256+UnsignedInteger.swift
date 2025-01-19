//

// MARK: - UnsignedInteger
// see: https://developer.apple.com/documentation/swift/unsignedinteger
extension UInt256: UnsignedInteger {
    
    public static let max = UInt256([UInt64.max, UInt64.max, UInt64.max, UInt64.max])
    public static let min = UInt256([UInt64.min, UInt64.min, UInt64.min, UInt64.min])

    public var magnitude: UInt256 {
        return UInt256(parts)
    }
}
