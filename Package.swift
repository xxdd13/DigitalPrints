// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "swift_mysql",
    dependencies:[
        .Package(url:"https://github.com/vapor/mysql", majorVersion:1)
    ]
)
