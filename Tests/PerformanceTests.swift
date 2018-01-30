//

import XCTest
@testable import UInt256

class PerformanceTests: XCTestCase {

    func testFullWidthMultiplicationPerformance() {
        self.measure {
            for _ in 0..<1000 {
                let a = arc4random256()
                let b = arc4random256()
                let _ = a.multipliedFullWidth(by: b)
            }
        }
    }

    func testFullWidthDivisionPerformace() {
        self.measure {
            for _ in 0..<1000 {
                let hi = arc4random256()
                let lo = arc4random256()
                let a = arc4random256()
                let _ = a.dividingFullWidth((hi, lo))
            }
        }
    }

    func testDivisionPerformance() {
        self.measure {
            for _ in 0..<1000 {
                let a = arc4random256()
                let b = arc4random256()
                let _ = a / b
            }
        }
    }

    func testDivideAndConquerPerf() {
        self.measure {
            for _ in 0..<1000 {
                let a = arc4random256()
                let b = arc4random256()
                let c = arc4random256()
                let _ = a.dividingFullWidth((high: c, low: b))
            }
        }
    }

    func testBarrettDivisionPerf() {
        self.measure {
            for _ in 0..<1000 {
                let hi = arc4random256()
                let lo = arc4random256()
                let a = arc4random256()
                let (invH, rH) = UInt256.divisionWithRemainder(UInt256.max, a)
                var (invL, rL) = a.dividingFullWidth((rH, UInt256.max))
                if rL == a - 1 {
                    invL = invL + 1
                }
                let (_, _) = a.dividingFullWidth((hi, lo), withPrecomputedInverse: (invH, invL))
            }
        }
    }
}
