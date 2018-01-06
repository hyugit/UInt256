
import Foundation

public struct UInt256 {
    var parts: [UInt64]

    public init() {
        self.init(withUInt64: 0)
    }

    public init(_ value: Int) {
        if value >= 0 {
            parts = [0, 0, 0, UInt64(value)]
        } else {
            parts = [
                UInt64.max,
                UInt64.max,
                UInt64.max,
                UInt64(truncatingIfNeeded: value)
            ]
        }
    }

    public init(_ value: UInt64) {
        self.init(withUInt64: value)
    }

    public init(withUInt64 value: UInt64) {
        parts = [0, 0, 0, value]
    }

    public init(_ value: UInt256) {
        parts = [value[0], value[1], value[2], value[3]]
    }

    public init(_ values: [UInt64]) {
        self.init(withUInt64Array: values)
    }

    public init(withUInt64Array values: [UInt64]) {
        var _parts = Array(values)
        while _parts.count < 4 {
            _parts.insert(0, at: 0)
        }
        parts = Array(_parts[0...3])
    }

    subscript(index: Int) -> UInt64 {
        get {
            return parts[index]
        }
        mutating set {
            parts[index] = UInt64(newValue)
        }
    }

    subscript(range: CountableClosedRange<Int>) -> [UInt64] {
        get {
            return Array(parts[range])
        }
    }

    public func toHexString() -> String {
        return String(format: "%0.16lx%0.16lx%0.16lx%0.16lx", parts[0], parts[1], parts[2], parts[3])
    }
}
