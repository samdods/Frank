//
//  HTTP.swift
//  Frank
//
//  Created by Sam Dods on 21/11/2018.
//  Copyright © 2018 Tesco. All rights reserved.
//

import Foundation

struct Request {
    
    let httpMethod: String
    let path: String
    
    init?(_ fd: Int32) {
        
        let input = read(fd)
        print(input)
        
        /*
             GET /hello HTTP/1.1
             Host: 127.0.0.1:8080
             User-Agent: curl/7.54.0
             Accept: ...
        */
        
        guard let firstLine = input.components(separatedBy: .newlines).first else { return nil }
        let components = firstLine.components(separatedBy: .whitespaces)
        
        guard let method = components.first,
            let path = components[safe: 1] else {
                return nil
        }
        
        print("HTTP Method: \(method)")
        print("Path: \(path)")
        
        self.httpMethod = method
        self.path = path
    }
}
