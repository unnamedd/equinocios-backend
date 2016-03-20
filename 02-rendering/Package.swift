import PackageDescription

let package = Package(
    name: "02-rendering",
    dependencies: [
        .Package(url: "https://github.com/Zewo/HTTPServer.git", majorVersion: 0, minor: 3),
    	.Package(url: "https://github.com/Zewo/Router.git", majorVersion: 0, minor: 3),
        .Package(url: "https://github.com/Zewo/LogMiddleware.git", majorVersion: 0, minor: 3),
        .Package(url: "https://github.com/Zewo/HTTPFile.git", majorVersion: 0, minor: 3),
        .Package(url: "https://github.com/Zewo/Sideburns.git", majorVersion: 0, minor: 3)
    ]
)
