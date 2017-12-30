//
// Created by MrYu87 on 12/29/17.
// Copyright (c) 2017 MrYu87. All rights reserved.
//

extension UInt256: Hashable {
    public var hashValue: Int {
        return toHexString().hashValue
    }
}
