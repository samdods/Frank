//
//  Server.swift
//  Frank
//
//  Created by Sam Dods on 21/11/2018.
//  Copyright © 2018 Tesco. All rights reserved.
//

import Foundation

var routedGET: [String: () -> String] = [:]

func get(_ path: String, body: @escaping (() -> String)) {
    routedGET[path] = body
}

struct Frank {
    
    static func start() {
        
        // MARK: - Create socket reference
        
        let sock = socket(AF_INET, SOCK_STREAM, 0)
        guard sock >= 0 else {
            fatalError("Failed to open socket")
        }
        
        
        // MARK: - Set option to reuse address
        //       (SO_REUSEADDR -> allows reusing the port if server was shutdown while port active)
        
        var reuse: Int32 = 1
        let length = socklen_t(MemoryLayout<Int32>.size)
        setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &reuse, length)
        
        
        // MARK: - Bind socket to address and port
        
        var address = sockaddr_in()
        let size = socklen_t(MemoryLayout<sockaddr_in>.size)
        
        address.sin_family = sa_family_t(AF_INET)
        address.sin_port = in_port_t(8080).bigEndian
        address.sin_addr.s_addr = INADDR_ANY
        
        guard bind(sock, &address, size) >= 0 else {
            fatalError("Failed to bind")
        }
        
        
        // MARK: - Listen on the socket
        
        guard listen(sock, SOMAXCONN) >= 0 else {
            fatalError("Listen failed")
        }
        
        
        while(true) {
            
            // MARK: - Accept request
            
            let fd = accept(sock, nil, nil)
            
            print("Connection made")
            
            guard fd >= 0 else {
                print("Can't accept connection")
                continue
            }
            
            guard let input = Request(fd) else { continue }
            guard input.httpMethod == "GET" else {
                print("HTTP method not supported")
                continue
            }
            guard let block = routedGET[input.path] else {
                let response = httpResponse(body: "Error", status: "404 Not Found")
                write(fd, response)
                close(fd)
                continue
            }
            
            // MARK: - Write response
            
            let body = block()
            
            let response = httpResponse(body: body)
            write(fd, response)
            
            // MARK: - Close request
            
            close(fd)
        }
    }
    
    private static func httpResponse(body: String, status: String = "200 OK") -> String {
        
        let contentLength = body.lengthOfBytes(using: .utf8)
        
        return """
        HTTP/1.1 \(status)
        Content-Type: text/html; charset=UTF-8
        Content-Length: \(contentLength)
        
        \(body)
        """
    }
}
