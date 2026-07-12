//
//  TabFrameKey.swift
//  ITabPager
//
//  Created by ibabyblue on 2026/04/30.
//  Copyright © 2026 ibabyblue. All rights reserved.
//

#if canImport(UIKit)
import SwiftUI

struct TabFrameKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue: [AnyHashable: CGRect] = [:]
    static func reduce(
        value: inout [AnyHashable: CGRect],
        nextValue: () -> [AnyHashable: CGRect]
    ) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct TabViewportFrameKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue: [AnyHashable: CGRect] = [:]
    static func reduce(
        value: inout [AnyHashable: CGRect],
        nextValue: () -> [AnyHashable: CGRect]
    ) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
#endif
