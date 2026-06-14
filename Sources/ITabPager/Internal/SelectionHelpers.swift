//
//  SelectionHelpers.swift
//  ITabPager
//
//  Created by ibabyblue on 2026/04/30.
//  Copyright © 2026 ibabyblue. All rights reserved.
//

// Pure Swift — no UIKit dependency, testable on macOS host
func validatedSelection<Tab: Hashable>(_ selection: Tab, in tabs: [Tab]) -> Tab? {
    tabs.contains(selection) ? selection : tabs.first
}
