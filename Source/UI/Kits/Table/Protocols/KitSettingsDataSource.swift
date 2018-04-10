//
//  KitSettingsDataSource
//  Created on 4/9/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import UIKit

protocol KitSettingsDataSource: class {
    var navigationTitle: String { get }
    
    var cellTypes: [UITableViewCell.Type] { get }
    
    var sections: [TableSection] { get }
    
    var rightBarButton: BarButton? { get }
    var startInEditingMode: Bool { get }
}

extension KitSettingsDataSource {
    var navigationTitle: String {
        return "Implement This"
    }
    
    var cellTypes: [UITableViewCell.Type] {
        return [
            EditKitSettingCell.self,
            EditKitSliderCell.self,
            EditKitInputCell.self
        ]
    }
    
    var sections: [TableSection] {
        return []
    }
    
    var rightBarButton: BarButton? {
        return nil
    }
    
    var startInEditingMode: Bool {
        return false
    }
}
