//
//  ExportedVectorAssets.swift
//  Slate
//
//  Created by John Coates on 6/9/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension DrawProxyDSL {
    static let coreAssets: [VectorImageAsset] = [
        
        // Kit
        KitSettingsImage(),
        EditKitDisclosureIndicator(),
        
        // Kit Edit Icons
        EditKitLayoutIcon(),
        EditKitPhotoIcon(),
        EditKitVideoIcon(),
        EditKitPreviewIcon(),
        
        // Kit Components
        SwitchCameraImage(),
        
        // Camera
        CameraPermissionsImage(),
        PhotosPermissionsImage(),
        
        // Editing
        EditingCheckmarkImage(),
        EditingCancelImage(),
        EditingDeleteImage(),
        
        // Common Icons
        InteractivityIndicatorImage(),
    ]
}
