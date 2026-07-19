//
//  OverflowAndEdgeFadeDemo.swift
//  ITabPagerDemo
//
//  Created by ibabyblue on 2026/05/08.
//  Copyright © 2026 ibabyblue. All rights reserved.
//

import ITabPager
import SwiftUI

/// Demonstrates an overflowing title strip, selection centering, and clipped-edge fades.
struct OverflowAndEdgeFadeDemo: View {
    /// The ordered titles that intentionally exceed the available strip width.
    let tabs = [
        "Following", "Recommended", "Trending", "Games", "Movies",
        "Music", "Sports", "Technology", "Finance", "Automotive",
        "Food", "Travel", "Fashion", "Health", "Education"
    ]

    /// The caller-owned selected overflow title.
    @State private var selection = "Recommended"

    /// A default style with tab-strip edge fading enabled.
    private var style: ITabPagerStyle {
        var style = ITabPagerStyle()
        style.showsTabStripEdgeFade = true
        return style
    }

    /// The overflow pager, observable selection, and list-backed pages.
    var body: some View {
        ITabPager(
            tabs: tabs,
            selection: $selection,
            style: style
        ) { tab in
            VStack(spacing: 0) {
                DemoStatusRow(
                    title: "Selection",
                    value: tab,
                    accessibilityIdentifier: DemoAccessibility.overflowSelection
                )
                .padding(.horizontal)
                .padding(.vertical, 10)

                List(1...40, id: \.self) { row in
                    HStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(color(for: tab))
                            .frame(width: 48, height: 48)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(tab) item \(row)")
                                .font(.headline)
                            Text("Scrollable content for the selected category")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.plain)
            }
        } tabTitle: { tab in
            tab
        }
        .navigationTitle("Overflow and Edge Fade")
        .navigationBarTitleDisplayMode(.inline)
    }

    /// Resolves a stable translucent accent color for a title's page rows.
    ///
    /// - Parameter tab: The title whose page is being rendered.
    /// - Returns: A palette color selected from the title's ordered index.
    private func color(for tab: String) -> Color {
        let colors: [Color] = [.blue, .red, .orange, .green, .purple, .pink, .teal, .indigo]
        let index = tabs.firstIndex(of: tab) ?? 0
        return colors[index % colors.count].opacity(0.3)
    }
}
