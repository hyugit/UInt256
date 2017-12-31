//
//  UInt256+FixedWidthInteger.swift
//  UInt256
//
//  Created by Huang Yu on 12/31/17.
//

import Foundation

extension UInt256: FixedWidthInteger {

    public init(_truncatingBits: UInt) {
        var result: [UInt64] = []
        for i in 0..<4 {
            let bits = _truncatingBits >> i * 64
            result.append(UInt64(_truncatingBits: bits))
        }
        self.init(result)
    }

    public var nonzeroBitCount: Int {
        return parts[0].nonzeroBitCount
            + parts[1].nonzeroBitCount
            + parts[2].nonzeroBitCount
            + parts[3].nonzeroBitCount
    }

    public var leadingZeroBitCount: Int {
        var result: Int = 0
        for value in parts {
            let count = value.leadingZeroBitCount
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

    public var byteSwapped: UInt256 {
        return UInt256([
            parts[3].byteSwapped,
            parts[2].byteSwapped,
            parts[1].byteSwapped,
            parts[0].byteSwapped,
        ])
    }
    
    public func addingReportingOverflow(_ rhs: UInt256) -> (partialValue: UInt256, overflow: Bool) {
        return (0, true)
    }
    
    public func subtractingReportingOverflow(_ rhs: UInt256) -> (partialValue: UInt256, overflow: Bool) {
        return (0, true)
    }
    
    public func multipliedReportingOverflow(by rhs: UInt256) -> (partialValue: UInt256, overflow: Bool) {
        return (0, true)
    }
    
    public func dividedReportingOverflow(by rhs: UInt256) -> (partialValue: UInt256, overflow: Bool) {
        return (0, true)
    }
    
    public func remainderReportingOverflow(dividingBy rhs: UInt256) -> (partialValue: UInt256, overflow: Bool) {
        return (0, true)
    }
    
    public func multipliedFullWidth(by other: UInt256) -> (high: UInt256, low: UInt256) {
        return (0, 0)
    }
    
    public func dividingFullWidth(_ dividend: (high: UInt256, low: UInt256)) -> (quotient: UInt256, remainder: UInt256) {
        return (0, 0)
    }
}