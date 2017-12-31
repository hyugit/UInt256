//
// Created by MrYu87 on 12/28/17.
// Copyright (c) 2017 MrYu87. All rights reserved.
//

extension UInt256: UnsignedInteger {
    
    public static var max = UInt256([UInt64.max, UInt64.max, UInt64.max, UInt64.max])
    public static var min = UInt256([UInt64.min,UInt64.min,UInt64.min, UInt64.min])
    
    public var magnitude: UInt256 {
        return UInt256(parts)
    }
}
