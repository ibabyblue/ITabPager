//
//  DemoComponents.swift
//  ITabPagerDemo
//
//  Created by OpenAI Codex on 2026/07/19.
//  Copyright © 2026 ibabyblue. All rights reserved.
//

import SwiftUI

/// A catalog row that presents one scenario's icon, title, and summary.
struct DemoCatalogLabel: View {
    /// The scenario described by this row.
    let scenario: DemoScenario

    /// The labeled two-line catalog presentation.
    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 3) {
                Text(scenario.title)
                Text(scenario.summary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        } icon: {
            Image(systemName: scenario.systemImage)
        }
    }
}

/// A labeled status value with a stable UI-test identifier.
struct DemoStatusRow: View {
    /// The leading status description.
    let title: String
    /// The observable trailing status value.
    let value: String
    /// The identifier applied to the value for UI tests.
    let accessibilityIdentifier: String

    /// The aligned label and monospaced value presentation.
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .font(.callout.monospaced())
                .foregroundStyle(.secondary)
                .accessibilityIdentifier(accessibilityIdentifier)
        }
    }
}

/// A reusable material card for scenario controls and status values.
struct DemoControlCard<Content: View>: View {
    /// The card content built during initialization.
    private let content: Content

    /// Creates a material-backed card from a SwiftUI content builder.
    ///
    /// - Parameter content: The controls or status rows displayed by the card.
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    /// The padded, rounded material card hierarchy.
    var body: some View {
        VStack(spacing: 12) {
            content
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}
