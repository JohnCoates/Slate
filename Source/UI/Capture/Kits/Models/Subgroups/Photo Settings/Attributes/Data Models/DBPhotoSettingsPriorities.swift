//
//  DBPhotoSettingsPriorities
//  Created on 4/9/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

@objc(DBPhotoSettingsPriorities)
class DBPhotoSettingsPriorities: NSObject, NSCoding {
    private var priorities: [Int]
    
    enum CodingKeys: String, CodingKey {
        case priorities
    }
    
    init(priorities: PhotoSettingsPriorities) {
        self.priorities = priorities.priorities.map {$0.rawValue}
    }
    
    required init?(coder nsDecoder: NSCoder) {
        let decoder = nsDecoder.keyed(by: CodingKeys.self)
        priorities = decoder[.priorities]
    }
    
    func encode(with nsEncoder: NSCoder) {
        let encoder = nsEncoder.keyed(by: CodingKeys.self)
        encoder[.priorities] = priorities
    }
    
    var value: PhotoSettingsPriorities {
        return PhotoSettingsPriorities(priorities: priorities)
    }
    
    override var description: String {
        return "[DBPhotoSettingsPriorities \(priorities)]"
    }
}
