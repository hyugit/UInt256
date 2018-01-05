//

extension UInt256: Hashable {
    public var hashValue: Int {
        return toHexString().hashValue
    }
}
