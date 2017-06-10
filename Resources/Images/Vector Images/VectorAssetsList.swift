//
//  VectorAssetsList.swift
//  Slate
//
//  Created by John Coates on 6/9/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

enum ImageFiles: String {
    case coreAssetFile = "coreAssets.cvif"
}

enum PermissionsImage: String {
    case camera = "Camera"
    case photos = "Photos"
    var section: String { return "Permissions" }
}

enum KitImage: String {
    case settings = "Settings"
    var section: String { return "Kit" }
}
