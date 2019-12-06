//
//  Bundle.swift
//  Drink More Water
//
//  Created by Andreas Behrend on 06.12.19.
//  Copyright © 2019 Andreas Behrend. All rights reserved.
//
//  Usage:
//  Bundle.main.releaseVersionNumber
//  Bundle.main.buildVersionNumber
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
