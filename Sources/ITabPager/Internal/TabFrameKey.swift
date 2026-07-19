//
//  TabFrameKey.swift
//  ITabPager
//
//  Created by ibabyblue on 2026/04/30.
//  Copyright © 2026 ibabyblue. All rights reserved.
//

#if canImport(UIKit)
import SwiftUI

/// Collects tab frames measured in the complete tab-strip coordinate space.
struct TabFrameKey: PreferenceKey {
    /// The empty frame dictionary used before tab labels are measured.
    nonisolated(unsafe) static var defaultValue: [AnyHashable: CGRect] = [:]
    /// Merges newly measured frames, with newer values replacing duplicate identities.
    ///
    /// - Parameters:
    ///   - value: The accumulated frame dictionary.
    ///   - nextValue: A closure that supplies the next subtree's frames.
    static func reduce(
        value: inout [AnyHashable: CGRect],
        nextValue: () -> [AnyHashable: CGRect]
    ) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

/// Collects tab frames measured relative to the visible scroll viewport.
struct TabViewportFrameKey: PreferenceKey {
    /// The empty viewport-frame dictionary used before tab labels are measured.
    nonisolated(unsafe) static var defaultValue: [AnyHashable: CGRect] = [:]
    /// Merges newly measured viewport frames, replacing duplicate identities with newer values.
    ///
    /// - Parameters:
    ///   - value: The accumulated viewport-frame dictionary.
    ///   - nextValue: A closure that supplies the next subtree's frames.
    static func reduce(
        value: inout [AnyHashable: CGRect],
        nextValue: () -> [AnyHashable: CGRect]
    ) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
#endif
