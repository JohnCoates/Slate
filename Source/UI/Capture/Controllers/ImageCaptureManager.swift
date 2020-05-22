//
//  ImageCaptureManager.swift
//  Slate
//
//  Created by John Coates on 5/23/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import Photos


class ImageCaptureManager: PermissionsManagerDelegate {
    
    // MARK: - Public Methods
    
    class func captured(imageData: Data) {
        sharedInstance.captured(imageData: imageData)
    }
    
    // MARK: - Private
    
    private static let sharedInstance = ImageCaptureManager()
    private init() {
    }
    
    lazy var permissionsManager: PermissionsManager = {
       return PermissionsManager(delegate: self)
    }()
    
    private var imageDataWaitingForPermissionToSave: Data?
    
    private func captured(imageData: Data) {
        if permissionsManager.hasPermission(for: .photos) {
            saveToPhotoLibrary(imageData: imageData)
        } else if permissionsManager.hasAvailableRequest(for: .photos) {
            imageDataWaitingForPermissionToSave = imageData
            DispatchQueue.main.async {
                self.permissionsManager.requestPermission(for: .photos)
            }
        } else {
            // save locally
        }
    }
    
    private func saveToPhotoLibrary(imageData: Data) {
        PHPhotoLibrary.shared().performChanges({ 
            guard let image = UIImage(data: imageData) else {
                print("Eror: Couldn't create image from data")
                return
            }
//            print("image size: \(image.size)")
            
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: { success, error in
            if let error = error {
                print("Error saving image: \(error)")
                return
            }
        })
    }
    
    // MARK: - Permissions Manager
    
    func enabled(permission: Permission) {
        guard permission == .photos else {
            return
        }
        
        if let imageData = imageDataWaitingForPermissionToSave {
            saveToPhotoLibrary(imageData: imageData)
            imageDataWaitingForPermissionToSave = nil
        }
    }
    
    func denied(permission: Permission) {
        guard permission == .photos else {
            return
        }
    }
    
}
