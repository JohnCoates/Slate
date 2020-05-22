//
//  FeatureCatalogViewController+Sections
//  Created on 2/26/19.
//  Copyright © 2019 John Coates. All rights reserved.
//

import UIKit

extension FeatureCatalogViewController {
    
    var _sections: [Section] {
        return [
            self.captureScreen(),
            self.permissions(),
            self.kitsTab(),
            self.database(),
            self.vectors(),
            self.buttons(),
            self.research()
        ]
    }
    
    func captureScreen() -> Section {
        let items: [FeatureCatalogItem] = [
            FeatureCatalogItem(name: "Capture Screen",
                               creationBlock: {CaptureViewController()}),
            FeatureCatalogItem(name: "Edit Bar",
                               creationBlock: {
                                let vc = CaptureViewController()
                                // trigger view load
                                _ = vc.view
                                vc.editBar.isHidden = false
                                return vc
            }),
            FeatureCatalogItem(name: "AV Preview", creationBlock: { AVPreviewCaptureViewController() }),
            FeatureCatalogItem(name: "Scaled", hideNavigation: true,
                               creationBlock: { LayoutPreviewCaptureViewController(kit: Kit.default()) })
        ]
        
        return Section(title: "Capture Screen", items: items)
    }
    
    func permissions() -> Section {
        var items: [FeatureCatalogItem] = [
            FeatureCatalogItem(name: "Camera Permission",
                               actionBlock: { PermissionsWindow.show(kind: .camera,
                                                                     animated: true)
            }),
            FeatureCatalogItem(name: "Camera Denied Permission",
                               actionBlock: { PermissionsWindow.show(kind: .cameraDenied,
                                                                     animated: true)
            }),
            FeatureCatalogItem(name: "Photos Permission",
                               actionBlock: { PermissionsWindow.show(kind: .photos,
                                                                     animated: true)
            }),
            FeatureCatalogItem(name: "Photos Denied Permission",
                               actionBlock: { PermissionsWindow.show(kind: .photosDenied,
                                                                     animated: true)
            }),
            FeatureCatalogItem(name: "Permissions Button Indicator",
                               creationBlock: {
                                let frame = CGRect(x: 160.5, y: 321.5, width: 134.5, height: 44)
                                return PermissionsButtonIndicatorViewController(buttonFrame: frame)
            })
        ]
        
        if Platform.isSimulator {
            items.append(FeatureCatalogItem(name: "Clear Permissions",
                                            actionBlock: { SimulatorPermissionsManager.removePermissions() }))
        }
        
        return Section(title: "Permissions", items: items)
    }
    
    func kitsTab() -> Section {
        let items: [FeatureCatalogItem] = [
            FeatureCatalogItem(name: "Kits",
                               creationBlock: { KitsViewController() }),
            FeatureCatalogItem(name: "Edit Kit",
                               creationBlock: { EditKitViewController(kit: Kit()) }),
            FeatureCatalogItem(name: "Edit Layout",
                               creationBlock: { EditKitLayoutViewController(kit: Kit.default()) }),
            FeatureCatalogItem(name: "Photo Settings",
                               creationBlock: { KitPhotoSettingsViewController(kit: Kit.default()) }),
            FeatureCatalogItem(name: "Resolution",
                               creationBlock: { ResolutionSettingViewController(kit: Kit.default()) }),
            FeatureCatalogItem(name: "Frame Rate",
                               creationBlock: { FrameRateSettingsViewController(kit: Kit.default()) }),
            FeatureCatalogItem(name: "Prority Order",
                               creationBlock: { PhotoSettingsPriorityViewController(kit: Kit.default()) })
        ]
        
        return Section(title: "Kits Tab", items: items)
    }
    
    func database() -> Section {
        let items: [FeatureCatalogItem] = [
            FeatureCatalogItem(name: "Components",
                               creationBlock: { ComponentListingsViewController() }),
            FeatureCatalogItem(name: "Kits",
                               creationBlock: { KitListingsViewController() })
        ]
        
        return Section(title: "Database", items: items)
    }
    
    func buttons() -> Section {
        let items: [FeatureCatalogItem] = [
            FeatureCatalogItem(name: "Inverted Mask Button",
                               creationBlock: { InvertedMaskButtonViewController(kind: .checkmark) }),
            FeatureCatalogItem(name: "Flip Camera Button",
                               creationBlock: { InvertedMaskButtonViewController(kind: .flipCamera) }),
            FeatureCatalogItem(name: "Button Indicator",
                               creationBlock: { InvertedMaskButtonViewController(kind: .buttonIndicator) })
        ]
        
        return Section(title: "Buttons", items: items)
    }
    
    func vectors() -> Section {
        let items: [FeatureCatalogItem] = [
            FeatureCatalogItem(name: "Assets",
                               creationBlock: { VectorImagesTableViewController() })
        ]
        
        return Section(title: "Vector Images", items: items)
    }
    
    func research() -> Section {
        let items: [FeatureCatalogItem] = [
            FeatureCatalogItem(name: "Send Motion Data",
                               creationBlock: { MotionSendViewController() })
        ]
        
        return Section(title: "Research", items: items)
    }
}
