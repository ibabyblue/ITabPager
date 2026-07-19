//
//  BasicPagingDemo.swift
//  ITabPagerDemo
//
//  Created by ibabyblue on 2026/05/08.
//  Copyright © 2026 ibabyblue. All rights reserved.
//

import ITabPager
import SwiftUI

/// The stable destinations displayed by the basic paging scene.
enum BasicTab: String, CaseIterable, Hashable {
    /// The recommended-feed destination.
    case recommended
    /// The popular-feed destination.
    case popular
    /// The latest-feed destination.
    case latest

    /// The user-facing title of this destination.
    var title: String { rawValue.capitalized }
}

/// Demonstrates default styling, tab taps, page swipes, and bound selection.
struct BasicPagingDemo: View {
    /// The caller-owned selected basic destination.
    @State private var selection: BasicTab = .recommended

    /// The default pager and list-backed content for the selected destination.
    var body: some View {
        ITabPager(
            tabs: BasicTab.allCases,
            selection: $selection
        ) { tab in
            VStack(spacing: 0) {
                DemoStatusRow(
                    title: "Selection",
                    value: tab.title,
                    accessibilityIdentifier: DemoAccessibility.basicSelection
                )
                .padding(.horizontal)
                .padding(.vertical, 10)

                List(1...30, id: \.self) { row in
                    Text("\(tab.title) item \(row)")
                }
                .listStyle(.plain)
            }
        } tabTitle: { tab in
            tab.title
        }
        .navigationTitle("Basic Paging")
        .navigationBarTitleDisplayMode(.inline)
    }
}
