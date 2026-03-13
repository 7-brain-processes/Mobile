// Package.swift
// ...
.products: [
    .executable(name: "mytool", targets: ["MyTool"])
],
.targets: [
    .executableTarget(
        name: "MyTool",
        dependencies: []
    )
]
