//
//  SimulatorPermissionsManager
//  Created on 4/13/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation
import SQLite3

struct SimulatorPermissionsManager {
    static func removePermissions() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let documentDirectory = paths[0]
        var url = URL(fileURLWithPath: documentDirectory)
        url.deleteLastPathComponent() // Document
        url.deleteLastPathComponent() // App GUID
        url.deleteLastPathComponent() // Application
        url.deleteLastPathComponent() // Data
        url.deleteLastPathComponent() // Containers
        url.appendPathComponent("Library")
        
        let tccDirectory = url.appendingPathComponent("TCC")
        let dbPath = tccDirectory.appendingPathComponent("TCC.db")
        
        var database: OpaquePointer?
        defer {
            sqlite3_close(database)
        }
        if sqlite3_open(dbPath.absoluteString, &database) != SQLITE_OK {
            fatalError("Couldn't open TCC DB")
        }
        
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            fatalError("Couldn't access bundle identifier")
        }
        
        let statement = "DELETE FROM access WHERE client  = '\(bundleIdentifier)'"
        var errMsg: UnsafeMutablePointer<Int8>? = nil
        
        if (sqlite3_exec(database, statement, nil, nil, &errMsg) != SQLITE_OK) {
            sqlite3_free(errMsg)
            fatalError("Failed to delete permissions")
        }
        
        print("Cleared permissions")
    }
}
