//
//  Defaults.swift
//  Drink More Water
//
//  Created by Andreas Behrend on 06.12.19.
//  Copyright © 2019 Andreas Behrend. All rights reserved.
//

import Foundation

struct Defaults {
    static var amount = 0
    static var interval = [60.0, 1800.0, 2700.0, 3600.0]
    static var overall = 0
    static var selectedInterval = 0;
}

enum DataError: Error {
    case noConfigFound
}
