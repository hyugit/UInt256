//

extension UInt256: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.toHexString().hashValue)
    }
}
