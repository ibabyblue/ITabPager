// swift-tools-version: 6.2
//
//  Package.swift
//  ITabPager
//
//  Created by ibabyblue on 2026/04/30.
//  Copyright © 2026 ibabyblue. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "ITabPager",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "ITabPager", targets: ["ITabPager"]),
    ],
    targets: [
        .target(name: "ITabPager"),
        .testTarget(name: "ITabPagerTests", dependencies: ["ITabPager"]),
    ]
)
