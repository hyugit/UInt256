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
            let hi = arc4random256()
            let lo = arc4random256()
            let a = arc4random256()
            let _ = UInt256.divideAndConquer((hi, lo), by: a)
        }
    }
}
