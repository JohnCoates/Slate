//
//  Discard
//  Created on 4/11/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

func discard<T>(value: T, ifZero maybeZero: Int) -> T? {
    if maybeZero == 0 {
        return nil
    } else {
        return value
    }
}

func discard(ifZero value: Int) -> Int? {
    if value == 0 {
        return nil
    } else {
        return value
    }
}
