# UInt256

A library for UInt256 written in Swift

The library is **heavily inspired** by [CryptoCoinSwift/UInt256](https://github.com/CryptoCoinSwift/UInt256)

The main struct UInt256 conforms to the following protocols: 
 - **UnsignedInteger**: this should be the top level protocol: see [here](https://github.com/apple/swift-evolution/blob/master/proposals/0104-improved-integers.md#proposed-solution)
 - **BinaryInteger**
 - **Numeric**
 - **CustomStringConvertible**
 - **Hashable**
 - **Comparable, Equatable**
 - etc (please see to the source code)

## TO DO

 - [ ] make UInt256 conform to FixedWidthInteger
 - [ ] add an example, preferably through a playground
 - [ ] more tests, test coverage and corner cases
 - [ ] automate build and test runs
 - [ ] karatsuba multiplication
 - [ ] fast modulo, division, and other algos
