//
//  VectorAssetsList.swift
//  Slate
//
//  Created by John Coates on 6/9/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

enum ImageFile: String {
    case coreAssets = "coreAssets.cvif"
}

enum PermissionsImage: String, ImageAsset {
    case camera = "Camera"
    case photos = "Photos"
    var section: String { return "Permissions" }
    var file: ImageFile { return .coreAssets }
}

enum KitImage: String, ImageAsset {
    case settings = "Settings"
    case disclosureIndicator = "DisclosureIndicator"
    var section: String { return "Kit" }
    var file: ImageFile { return .coreAssets }
}

enum KitEditImage: String, ImageAsset {
    case layout = "Layout"
    case photo = "Photo"
    case video = "Video"
    case preview = "Preview"
    var section: String { return "Kit.Edit" }
    var file: ImageFile { return .coreAssets }
}

enum KitComponent: String, ImageAsset {
    case switchCamera = "SwitchCamera"
    var section: String { return "Kit.Components" }
    var file: ImageFile { return .coreAssets }
}

enum EditingImage: String, ImageAsset {
    case checkmark = "Checkmark"
    case cancel = "Cancel"
    case delete = "Delete"
    var section: String { return "Editing" }
    var file: ImageFile { return .coreAssets }
}

protocol ImageAsset {
    var rawValue: String { get }
    var section: String { get }
    var file: ImageFile { get }
}

extension ImageAsset {
    var identifier: String {
        return "\(self.section).\(self.rawValue)"
    }
}
