//

extension UInt256: Equatable {
    public static func ==(_ lhs: UInt256, _ rhs: UInt256) -> Bool {
        return lhs[0] == rhs[0] &&
            lhs[1] == rhs[1] &&
            lhs[2] == rhs[2] &&
            lhs[3] == rhs[3]
    }
}
