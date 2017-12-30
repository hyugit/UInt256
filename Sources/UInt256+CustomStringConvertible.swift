//
// Created by MrYu87 on 12/28/17.
// Copyright (c) 2017 MrYu87. All rights reserved.
//

extension UInt256: CustomStringConvertible {
    public var description: String {
        return toHexString()
    }
}
