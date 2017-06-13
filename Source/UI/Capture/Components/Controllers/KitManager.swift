//
//  KitManager.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreData

class KitManager {
    
    static let currentKit: Kit = {
        let context = DataManager.context
        
        let fetchRequest = KitCoreData.sortedFetchRequest
        let results: [KitCoreData]
        do {
            results = try context.fetch(fetchRequest)
        } catch let error {
            print("Failed to fetch from Core Data store: \(error)")
            return Kit()
        }
        
        if results.count == 0 {
            return Kit()
        }
        
        let kit = results[0].instance()        
        return kit
    }()
    
}
