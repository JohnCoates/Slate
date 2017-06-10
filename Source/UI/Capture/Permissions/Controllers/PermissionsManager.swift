//
//  PermissionsManager.swift
//  Slate
//
//  Created by John Coates on 5/22/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import AVFoundation
import Photos

enum Permission {
    case camera
    case photos
}

protocol PermissionsManagerDelegate: class {
    func enabled(permission: Permission)
    func denied(permission: Permission)
//    func dismissed(permission: Permission)
}

final class PermissionsManager {
    
    // cache auth status
    
    var cameraStatus: AVAuthorizationStatus = {
       return AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
    }()
    lazy var photosStatus: PHAuthorizationStatus = {
        return PHPhotoLibrary.authorizationStatus()
    }()
    
    weak var delegate: PermissionsManagerDelegate?
    
    init(delegate: PermissionsManagerDelegate? = nil) {
        self.delegate = delegate
    }
    
    func hasPermission(for permission: Permission) -> Bool {
        switch permission {
        case .camera:
            return cameraStatus == .authorized
        case .photos:
            return photosStatus == .authorized
        }
    }
    
    func hasAvailableRequest(for permission: Permission) -> Bool {
        switch permission {
        case .camera:
            if cameraStatus == .notDetermined {
                return true
            } else {
                return false
            }
        case .photos:
            if photosStatus == .notDetermined {
                return true
            } else {
                return false
            }
        }
    }
    
    func requestPermission(for permission: Permission) {
        switch permission {
        case .camera:
            PermissionsWindow.show(kind: .camera, animated: true, delegate: delegate)
        case .photos:
            PermissionsWindow.show(kind: .photos, animated: true, delegate: delegate)
        }
    }
    
}
