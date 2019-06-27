//

extension UInt256: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.toHexString().hashValue)
    }

    public var hashValue: Int {
        return toHexString().hashValue
    }
}
