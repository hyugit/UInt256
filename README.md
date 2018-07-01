# UInt256

[![Build Status](https://travis-ci.org/hyugit/UInt256.svg?branch=master)](https://travis-ci.org/hyugit/UInt256)
[![Language](https://img.shields.io/badge/swift-4-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-ios%20|%20macos-lightgrey.svg)](https://github.com/hyugit/UInt256)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-green.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/badge/CocoaPods-compatible-green.svg?style=flat)](https://cocoapods.org/)


A UInt256 library written in Swift 4, **inspired** by [CryptoCoinSwift/UInt256](https://github.com/CryptoCoinSwift/UInt256)

## Features

This library provides a UInt256 struct that conforms nicely to Swift's **FixedWidthInteger** and **UnsignedInteger** protocols. According to Apple, the two are the necessary top level protocols for an UInt member: [here](https://github.com/apple/swift-evolution/blob/master/proposals/0104-improved-integers.md#proposed-solution)

It supports a complete set of arithmetic operations, as well as properties and functions that are common to other UInt family members such as `UInt64`, `UInt32`, `UInt8`, etc. The library leverages [Karatsuba fast multiplication](https://en.wikipedia.org/wiki/Karatsuba_algorithm) algorithm, [Divide and Conquer](http://bioinfo.ict.ac.cn/~dbu/AlgorithmCourses/Lectures/Hasselstrom2003.pdf) division algorithm, [Barrett Algorithm](https://members.loria.fr/PZimmermann/mca/mca-cup-0.5.9.pdf) for division and other efficient algos for other operators. Other features include integer literal representation (`ExpressibleByIntegerLiteral`), default description (`CustomStringConvertible`) and `Hashable`.

The library is written entirely in **Swift 4**. It can be installed as a **Swift Package**, a **Carthage package** or a **CocoaPod**. And a playground is also included as a testbench.

Please feel free to submit new feature requests and report issues here on GitHub. :smiley:

### Please use the playground to try out all the features!

## Swift Protocol Conformance

The main struct UInt256 conforms strictly to the following protocols: 
 - **FixedWidthInteger**
 - **UnsignedInteger**
 - **BinaryInteger**
 - **Numeric**
 - **Comparable**
 - **Equatable**
 - **CustomStringConvertible**
 - **Hashable**
 
## Requirements

 - iOS 8.0+ / macOS 10.10+
 - Xcode 8.0+
 - Swift 4

## Communication

If you need any help or have a feature request, please open an issue here on GitHub;
if you found a bug or want to help with the development, please submit a pull request.
All contributions are welcome! :smiley:

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
github "hyu2018/UInt256"
```

Finally, run `carthage update` to build the framework, and drag the built framework
(either `UInt256_iOS.framework` or `UInt256_macOS.framework`) into your Xcode project

### Swift Package Manager

This library supports **Swift Package Manager** as well. If you have your swift package
config set up already, please add the following line to your **Package.swift**:

```
dependencies: [
    .package(url: "https://github.com/hyu2018/UInt256.git", from: "4.0.0")
]
```

### CocoaPods

Install CocoaPods following its [official guide](http://guides.cocoapods.org/using/getting-started.html#installation)

To integrate UInt256 into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'UInt256', :git => 'https://github.com/hyu2018/UInt256.git'
end
```

And run `pod install` afterwards.

### Manual installation

You can also add this library manually to your project.

In the terminal, under your top level project directory, add this library as a
`git submodule` by running the following command:

```
git submodule add https://github.com/hyu2018/UInt256.git
```

Have Xcode open, go to your new `UInt256` subdirectory in Finder, drag
`UInt256.xcodeproj` into the project navigator of your project. _Remember to embed
the framework to your build target._

## Next steps...

 - [ ] add documentation
 - [ ] look into leveraging GPU/Metal
 - [x] benchmark
 - [x] make UInt256 conform to FixedWidthInteger
 - [x] add an example, preferably through a playground
 - [x] add CocoaPods support
 - [x] more tests, test coverage, corner cases, lint, code review
 - [x] automate build and test runs
 - [x] karatsuba multiplication
 - [x] fast modulo, division, and other algos

## License

This library is released under the MIT license. Please see [LICENSE](https://github.com/hyu2018/UInt256/blob/master/LICENSE)
