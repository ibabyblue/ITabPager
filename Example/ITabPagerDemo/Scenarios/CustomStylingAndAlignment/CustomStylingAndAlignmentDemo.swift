//
//  CustomStylingAndAlignmentDemo.swift
//  ITabPagerDemo
//
//  Created by ibabyblue on 2026/05/08.
//  Copyright © 2026 ibabyblue. All rights reserved.
//

import ITabPager
import SwiftUI

/// Demonstrates fitted center alignment and the complete style customization surface.
struct CustomStylingAndAlignmentDemo: View {
    /// The ordered custom-style category titles.
    let tabs = ["All", "Video", "Articles", "Live"]
    /// The caller-owned selected custom-style category.
    @State private var selection = "All"

    /// The orange-accented typography, indicator, and spacing configuration.
    private var customStyle: ITabPagerStyle {
        var style = ITabPagerStyle()
        style.selectedFont = .system(size: 15, weight: .semibold)
        style.unselectedFont = .system(size: 15, weight: .regular)
        style.selectedColor = .orange
        style.unselectedColor = .secondary
        style.indicatorColor = .orange
        style.indicatorWidthRatio = 0.7
        style.indicatorHeight = 2
        style.indicatorSpacing = 6
        style.tabSpacing = 24
        return style
    }

    /// The center-aligned custom pager and observable selected category.
    var body: some View {
        ITabPager(
            tabs: tabs,
            selection: $selection,
            alignment: .center,
            style: customStyle
        ) { tab in
            VStack(spacing: 0) {
                DemoStatusRow(
                    title: "Selection",
                    value: tab,
                    accessibilityIdentifier: DemoAccessibility.customSelection
                )
                .padding(.horizontal)
                .padding(.vertical, 10)

                List(1...25, id: \.self) { row in
                    Label("\(tab) item \(row)", systemImage: icon(for: tab))
                }
                .listStyle(.plain)
            }
        } tabTitle: { tab in
            tab
        }
        .navigationTitle("Custom Styling and Alignment")
        .navigationBarTitleDisplayMode(.inline)
    }

    /// Resolves the page-row SF Symbol for a custom-style category.
    ///
    /// - Parameter tab: The category whose icon is requested.
    /// - Returns: An SF Symbols name associated with `tab`.
    private func icon(for tab: String) -> String {
        switch tab {
        case "Video": "play.rectangle"
        case "Articles": "doc.richtext"
        case "Live": "antenna.radiowaves.left.and.right"
        default: "square.grid.2x2"
        }
    }
}
