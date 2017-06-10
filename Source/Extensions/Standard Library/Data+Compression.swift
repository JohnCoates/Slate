//
//  Data+Compression.swift
//  Slate
//
//  Created by John Coates on 6/8/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import Compression

extension Data {
    
    func compress(withAlgorithm algorithm: Compression.Algorithm) throws -> Data {
        let result = try performOperation(kind: .compression, algorithm: algorithm)
        return result
    }
    
    func decompress(withAlgorithm algorithm: Compression.Algorithm) throws -> Data {
        let result = try performOperation(kind: .decompression, algorithm: algorithm)
        return result
    }
    
    private func performOperation(kind: Compression.Kind, algorithm: Compression.Algorithm) throws -> Data {
        let scratchSize = compression_encode_scratch_buffer_size(algorithm.rawValue)
        var destination = Data(count: self.count * 4)
        
        let sourceBuffer: UnsafePointer<UInt8> = self.withUnsafeBytes { $0 }
        let destinationBuffer: UnsafeMutablePointer<UInt8> = destination.withUnsafeMutableBytes { $0 }
        let scratchBuffer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>.allocate(capacity: scratchSize)
        
        let bytes: Int
        if kind == .compression {
            bytes = compression_encode_buffer(destinationBuffer, destination.count,
                                              sourceBuffer, self.count,
                                              scratchBuffer, algorithm.rawValue)
        } else {
            bytes = compression_decode_buffer(destinationBuffer, destination.count,
                                              sourceBuffer, self.count,
                                              scratchBuffer, algorithm.rawValue)
        }
        
        scratchBuffer.deallocate(capacity: scratchSize)
        
        if bytes == 0 {
            if kind == .compression {
                throw Compression.Error.failed(message: "Compression failed")
            } else {
                throw Compression.Error.failed(message: "Decompression failed")
            }
        }
        
        destination.removeSubrange(bytes..<destination.count)
        return destination
    }
}

struct Compression {
    fileprivate enum Kind {
        case compression
        case decompression
    }
    enum Error: Swift.Error {
        case failed(message: String)
    }
    enum Algorithm {
        case lzma
        case lz4
        case lz4Raw
        case zlib
        case lzfse
        
        var rawValue: compression_algorithm {
            switch self {
            case .lzma:
                return COMPRESSION_LZMA
            case .lz4:
                return COMPRESSION_LZ4
            case .zlib:
                return COMPRESSION_ZLIB
            case .lz4Raw:
                return COMPRESSION_LZ4_RAW
            case .lzfse:
                return COMPRESSION_LZFSE
            }
        }
    }
}
