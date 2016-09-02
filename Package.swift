import PackageDescription

let package = Package(
    name: "HTMLParser",
    dependencies: [
        // Module map for `libxml2`
        .Package(url: "https://github.com/collinhundley/CLibXML2", majorVersion: 0, minor: 2)
    ]
)
