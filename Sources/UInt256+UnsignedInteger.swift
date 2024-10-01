//

// MARK: - UnsignedInteger
// see: https://developer.apple.com/documentation/swift/unsignedinteger
extension UInt256: UnsignedInteger {
    
    nonisolated(unsafe) public static var max = UInt256([UInt64.max, UInt64.max, UInt64.max, UInt64.max])
    nonisolated(unsafe) public static var min = UInt256([UInt64.min, UInt64.min, UInt64.min, UInt64.min])

    public var magnitude: UInt256 {
        return UInt256(parts)
    }
}
