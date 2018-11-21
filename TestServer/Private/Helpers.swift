//
//  Helpers.swift
//  TestServer
//
//  Created by Sam Dods on 21/11/2018.
//  Copyright © 2018 Tesco. All rights reserved.
//

import Foundation

func memCast<T, U, Result>(from original: inout T, _ body: @escaping (UnsafeMutablePointer<U>) throws -> Result) rethrows -> Result {
    return try withUnsafePointer(to: &original) { pointer -> Result in
        let size = MemoryLayout<U>.size
        return try pointer.withMemoryRebound(to: U.self, capacity: size, { pointer -> Result in
            let ptr = UnsafeMutablePointer(mutating: pointer)
            return try body(ptr)
        })
    }
}

func bind(_ sock: Int32, _ address: inout sockaddr_in, _ size: socklen_t) -> Int32 {
    return memCast(from: &address) { pointer in
        bind(sock, pointer, size)
    }
}

func write(_ fd: Int32, _ string: String) {
    _ = string.withCString { pointer in
        write(fd, pointer, strlen(pointer))
    }
}

func read(_ fd: Int32) -> String {
    let size = PIPE_BUF
    var bytes = Data(count: Int(size))
    
    return bytes.withUnsafeMutableBytes { (pointer: UnsafeMutablePointer<Data>) in
        _ = Darwin.read(fd, pointer, Int(size))
        let size = MemoryLayout<UInt8>.size
        
        let immutable = UnsafePointer<Data>(pointer)
        return immutable.withMemoryRebound(to: UInt8.self, capacity: size, String.init)
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        if index < count {
            return self[index]
        }
        return nil
    }
}
