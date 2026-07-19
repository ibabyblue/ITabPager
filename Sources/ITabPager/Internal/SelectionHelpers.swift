//
//  SelectionHelpers.swift
//  ITabPager
//
//  Created by ibabyblue on 2026/04/30.
//  Copyright © 2026 ibabyblue. All rights reserved.
//

#if canImport(UIKit)
import SwiftUI

/// Resolves a candidate selection against the current ordered tabs.
///
/// - Parameters:
///   - selection: The candidate selected identity.
///   - tabs: The currently available identities in display order.
/// - Returns: The candidate when present, the first tab when invalid, or `nil` when empty.
func validatedSelection<Tab: Hashable>(_ selection: Tab, in tabs: [Tab]) -> Tab? {
    tabs.contains(selection) ? selection : tabs.first
}

/// Returns the anchor used when scrolling the selected title into view.
///
/// - Returns: The center of the tab-strip viewport.
func selectedTabScrollAnchor() -> UnitPoint {
    .center
}
#endif
