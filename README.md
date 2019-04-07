# Frank

Frank is a proof of concept, standalone Swift server demonstrating how a Swift server can be built from scratch without any dependencies. Its usage is loosely based on Ruby's [Sinatra](http://sinatrarb.com) framework and Frank could in theory be turned into a framework itself.

It's very, very basic!

An alternative for building a new server-side Swift framework is to build on top of Apple's [SwiftNIO](https://github.com/apple/swift-nio).

Or just use [one](https://github.com/vapor/vapor) [of](https://github.com/amzn/smoke-framework) [the](https://github.com/IBM-Swift/Kitura) [numerous](https://github.com/PerfectlySoft/Perfect) server-side Swift frameworks already gaining popularity.

## Getting Started

Setup endpoints like so:

```
get("/home") {
    return "🏠"
}

get("/people") {
    return """
        <html><head><style>
        h1 { font-size:4cm; text-align: center }
        </style></head>
          <body><h1>👫👫👫👫👫</h1></body>
        </html>
        """
}
```

Then begin running like so:

```
Frank.start()
```

## Limitations

Err, everything is limited.

* The only supported HTTP method is **GET**.
* The only supported content type is **text/html**.
* It does not support inspection of variables in URL.
* It does not support inspection of query parameters.

Basically, it's pretty useless, unless your intended use is to demonstrate how a very simple server is made from scratch in Swift, using no dependencies. For that I think it's just about OK.

## Roadmap

This was a proof of concept. I have no intention of building this out into something useful.
