//
//  Helpers.swift
//  Frank
//
//  Created by Sam Dods on 21/11/2018.
//  Copyright © 2018 Tesco. All rights reserved.
//

import Foundation

/// Cast from one pointer type to another.
private func memCast<T, U, Result>(from original: inout T, _ body: @escaping (UnsafeMutablePointer<U>) throws -> Result) rethrows -> Result {
    return try withUnsafePointer(to: &original) { pointer -> Result in
        let size = MemoryLayout<U>.size
        return try pointer.withMemoryRebound(to: U.self, capacity: size, { pointer -> Result in
            let ptr = UnsafeMutablePointer(mutating: pointer)
            return try body(ptr)
        })
    }
}

/// Swift-friendly wrapper around Darwin's `bind` function.
func bind(_ sock: Int32, _ address: inout sockaddr_in, _ size: socklen_t) -> Int32 {
    return memCast(from: &address) { pointer in // pointer is inferred as type `const struct sockaddr *` from where it's passed into Darwin's `bind` function.
        bind(sock, pointer, size)
    }
}

/// Swift-friendly wrapper around Darwin's `write` function.
func write(_ fd: Int32, _ string: String) {
    _ = string.withCString { pointer in // Converts from Swift string to C string.
        write(fd, pointer, strlen(pointer))
    }
}

/// Swift-friendly wrapper around Darwin's `read` function. It's a poor
/// implementation because it assumes the incoming message is no longer
/// that the maximum number of bytes for atomic pipe writes (PIPE_BUF),
/// which is obviously not guaranteed. But it's suitable for this demo.
func read(_ fd: Int32) -> String {
    let size = PIPE_BUF
    var bytes = Data(count: Int(size))
    
    return bytes.withUnsafeMutableBytes { (pointer: UnsafeMutablePointer<Data>) in
        _ = Darwin.read(fd, pointer, Int(size))
        let size = MemoryLayout<UInt8>.size
        
        let immutable = UnsafePointer<Data>(pointer)
        
        // Return Swift string built from data as a collection of bytes.
        return immutable.withMemoryRebound(to: UInt8.self, capacity: size, String.init)
    }
}

extension Array {
    /// Safely return the element at the given index, if it exists.
    /// Otherwise return `nil`.
    subscript(safe index: Int) -> Element? {
        if index < count {
            return self[index]
        }
        return nil
    }
}
