//
//  main.swift
//  Frank
//
//  Created by Sam Dods on 17/10/2018.
//  Copyright © 2018 Tesco. All rights reserved.
//

import Foundation

get("/home") {
    return """
        <html><head><style>
        body { background-color: #111 }
        h1 { font-size:4cm; text-align: center }
        </style></head>
          <body>
            <h1>🏠</h1>
          </body>
        </html>
        """
}

Frank.start()
