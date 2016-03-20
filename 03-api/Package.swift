import PackageDescription

let package = Package(
    name: "todo-api",
    dependencies: [
        .Package(url: "https://github.com/Zewo/Zewo.git", majorVersion: 0, minor: 3),
        .Package(url: "https://github.com/Zewo/BasicAuthMiddleware.git", majorVersion: 0, minor: 3),        
    ]
)
