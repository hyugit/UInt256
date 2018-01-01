# UInt256

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Language](https://img.shields.io/badge/swift-4-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-ios%20|%20macos-lightgrey.svg)](https://github.com/mryu87/UInt256)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)


A UInt256 library written in Swift 4, **heavily influenced** by [CryptoCoinSwift/UInt256](https://github.com/CryptoCoinSwift/UInt256)

## Features

The main struct UInt256 conforms to the following protocols: 
 - **FixedWidthInteger**: _Currently under development_
 - **UnsignedInteger**: this should be the top level protocol: see [here](https://github.com/apple/swift-evolution/blob/master/proposals/0104-improved-integers.md#proposed-solution)
 - **BinaryInteger**
 - **Numeric**
 - **CustomStringConvertible**
 - **Hashable**
 - **Comparable, Equatable**
 - etc (please see to the source code)

A complete set of arithmetic operators are implemented, so are properties and functions
commonly found on other UInt family members (`Uint64`, `UInt32`, `UInt16`, etc).

A playground is also included as a testbench.

Other features, such as fast multiplication and CocoaPods support are in the development pipeline.
Please feel free to submit new feature request by opening issues here on GitHub. :smiley:

## Requirements

 - iOS 8.0+ / macOS 10.10+
 - Xcode 8.0+
 - Swift 4

## Communication

If you need any help or have a feature request, please open an issue here on GitHub;
if you found a bug or want to help with the development, please submit a pull request.
All contributions are welcome!

## Installation

### Carthage

First, make sure have Carthage installed:

```
brew update
brew install carthage
```

To integrate this library into your Xcode project, simply put the following line into
your `carfile`:

```
github "mryu87/UInt256"
```

Finally, run `carthage update` to build the framework, and drag the built framework
(either `UInt256_iOS.framework` or `UInt256_macOS.framework`) into your Xcode project

### Swift Package Manager

This library supports **Swift Package Manager** as well. If you have your swift package
config set up already, please add the following line to your **Package.swift**:

```
dependencies: [
    .package(url: "https://github.com/mryu87/UInt256.git", from: "4.0.0")
]
```

### Manual installation

You can also add this library manually to your project.

In the terminal, under your top level project directory, add this library as a
`git submodule` by running the following command:

```
git submodule add https://github.com/mryu87/UInt256.git
```

Have Xcode open, go to your new `UInt256` subdirectory in Finder, drag
`UInt256.xcodeproj` into the project navigator of your project. _Remember to embed
the framework to your build target._

## TO DO

 - [ ] make UInt256 conform to FixedWidthInteger
 - [x] add an example, preferably through a playground
 - [ ] add documentation
 - [ ] add CocoaPods support
 - [ ] more tests, test coverage, corner cases, lint, code review
 - [ ] automate build and test runs
 - [ ] benchmark
 - [ ] karatsuba multiplication
 - [ ] fast modulo, division, and other algos

## License

This library is released under the MIT license. Please see [LICENSE](https://github.com/mryu87/UInt256/blob/master/LICENSE)
