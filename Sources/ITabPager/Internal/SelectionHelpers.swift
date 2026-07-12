//
//  SelectionHelpers.swift
//  ITabPager
//
//  Created by ibabyblue on 2026/04/30.
//  Copyright © 2026 ibabyblue. All rights reserved.
//

#if canImport(UIKit)
import SwiftUI

// Pure helpers — no direct UIKit dependency, testable in the package suite
func validatedSelection<Tab: Hashable>(_ selection: Tab, in tabs: [Tab]) -> Tab? {
    tabs.contains(selection) ? selection : tabs.first
}

func selectedTabScrollAnchor() -> UnitPoint {
    .center
}
#endif
