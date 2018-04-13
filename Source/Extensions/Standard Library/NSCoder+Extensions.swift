//
//  NSCoder+Extensions
//  Created on 4/7/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

struct CodingKeyCoder<Key> where Key: CodingKey {
    let coder: NSCoder
    init(coder: NSCoder, keys: Key.Type) {
        self.coder = coder
    }
    
    subscript<Kind: AnyObject>(name: Key) -> Kind {
        get {
            return coder[name]
        }
        
        nonmutating
        set {
            coder[name] = newValue
        }
    }
    
    subscript<Kind: Any>(name: Key) -> [Kind] {
        get {
            return coder[name]
        }
        nonmutating
        set {
            coder[name] = newValue
        }
    }

    subscript(name: Key) -> Bool {
        get {
            return coder.decodeBool(forKey: name.stringValue)
        }
        
        nonmutating
        set {
            coder.encode(newValue, forKey: name.stringValue)
        }
    }
    
    subscript(name: Key) -> Int {
        get {
            return coder.decodeInteger(forKey: name.stringValue)
        }
        
        nonmutating
        set {
            coder.encode(newValue, forKey: name.stringValue)
        }
    }
    
    subscript(name: Key) -> Int32 {
        get {
            return coder.decodeInt32(forKey: name.stringValue)
        }
        
        nonmutating
        set {
            coder.encode(newValue, forKey: name.stringValue)
        }
    }
    
    subscript(name: Key) -> Int64 {
        get {
            return coder.decodeInt64(forKey: name.stringValue)
        }
        
        nonmutating
        set {
            coder.encode(newValue, forKey: name.stringValue)
        }
    }
    
    subscript(name: Key) -> Float {
        get {
            return coder.decodeFloat(forKey: name.stringValue)
        }
        
        nonmutating
        set {
            coder.encode(newValue, forKey: name.stringValue)
        }
    }
    
    subscript(name: Key) -> Double {
        get {
            return coder.decodeDouble(forKey: name.stringValue)
        }
        
        nonmutating
        set {
            coder.encode(newValue, forKey: name.stringValue)
        }
    }
    
    // MARK: - UI Geometry
    
    subscript(name: Key) -> CGPoint {
        get {
            return coder.decodeCGPoint(forKey: name.stringValue)
        }
        
        nonmutating
        set {
            coder.encode(newValue, forKey: name.stringValue)
        }
    }
    
    subscript(name: Key) -> CGVector {
        get {
            return coder.decodeCGVector(forKey: name.stringValue)
        }
        
        nonmutating
        set {
            coder.encode(newValue, forKey: name.stringValue)
        }
    }
    
    subscript(name: Key) -> CGSize {
        get {
            return coder.decodeCGSize(forKey: name.stringValue)
        }
        
        nonmutating
        set {
            coder.encode(newValue, forKey: name.stringValue)
        }
    }
    
    subscript(name: Key) -> CGRect {
        get {
            return coder.decodeCGRect(forKey: name.stringValue)
        }
        
        nonmutating
        set {
            coder.encode(newValue, forKey: name.stringValue)
        }
    }
    
    subscript(name: Key) -> CGAffineTransform {
        get {
            return coder.decodeCGAffineTransform(forKey: name.stringValue)
        }
        
        nonmutating
        set {
            coder.encode(newValue, forKey: name.stringValue)
        }
    }
    
    subscript(name: Key) -> UIEdgeInsets {
        get {
            return coder.decodeUIEdgeInsets(forKey: name.stringValue)
        }
        
        nonmutating
        set {
            coder.encode(newValue, forKey: name.stringValue)
        }
    }
    
    @available(iOS 11.0, *)
    subscript(name: Key) -> NSDirectionalEdgeInsets {
        get {
            return coder.decodeDirectionalEdgeInsets(forKey: name.stringValue)
        }
        
        nonmutating
        set {
            coder.encode(newValue, forKey: name.stringValue)
        }
    }
    
    func set(_ name: Key, to: Any) {
        coder[name] = to
    }
    
    func contains(_ key: Key) -> Bool {
        return coder.contains(key)
    }
}

extension NSCoder {
    
    subscript<Kind: Any>(name: CodingKey) -> Kind {
        get {
            guard let value = decodeObject(forKey: name.stringValue) as? Kind else {
                fatalError("Couldn't decode \(name) to \(Kind.self)")
            }
            
            return value
        }
        
        set {
            encode(newValue, forKey: name.stringValue)
        }
    }
    
    func contains(_ key: CodingKey) -> Bool {
        return containsValue(forKey: key.stringValue)
    }
    
    func keyed<Key>(by: Key.Type) -> CodingKeyCoder<Key> {
        return CodingKeyCoder.init(coder: self, keys: by)
    }
}
