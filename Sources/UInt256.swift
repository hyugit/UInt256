
import Foundation

public struct UInt256 {
    var parts: [UInt64]

    public init() {
        self.init(0)
    }

    public init(_ value: Int) {
        self.init(UInt64(value))
    }

    public init(_ value: UInt64) {
        parts = [0, 0, 0, value]
    }

    public init(_ value: UInt256) {
        parts = [value[0], value[1], value[2], value[3]]
    }

    public init(_ values: [UInt64]) {
        parts = [values[0], values[1], values[2], values[3]]
    }

    subscript(index: Int) -> UInt64 {
        get {
            return parts[index]
        }
        mutating set {
            parts[index] = UInt64(newValue)
        }
    }

    public func toHexString() -> String {
        return String(format: "%0.16lx%0.16lx%0.16lx%0.16lx", parts[0], parts[1], parts[2], parts[3])
    }
}
