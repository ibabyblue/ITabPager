//
//  ProgrammaticSelectionAndLifecycleDemo.swift
//  ITabPagerDemo
//
//  Created by OpenAI Codex on 2026/07/19.
//  Copyright © 2026 ibabyblue. All rights reserved.
//

import ITabPager
import Observation
import SwiftUI

/// The stable destinations used by the programmatic navigation scene.
enum ProgrammaticTab: String, CaseIterable, Hashable {
    /// The overview destination.
    case overview
    /// The activity destination.
    case activity
    /// The library destination.
    case library
    /// The profile destination.
    case profile

    /// The user-facing title of this destination.
    var title: String { rawValue.capitalized }

    /// The SF Symbols name associated with this destination.
    var systemImage: String {
        switch self {
        case .overview: "rectangle.grid.2x2"
        case .activity: "waveform.path.ecg"
        case .library: "books.vertical"
        case .profile: "person.crop.circle"
        }
    }
}

/// Shared mutable state observed by both the parent scene and separately hosted pager pages.
@MainActor
@Observable
final class ProgrammaticDemoModel {
    /// The destination currently requested through the pager binding.
    var selection: ProgrammaticTab = .overview
    /// Appearance counts recorded by lazily created page roots.
    private(set) var appearances: [ProgrammaticTab: Int] = [:]

    /// Creates a model with the overview destination selected and no recorded appearances.
    init() {}

    /// A compact ordered summary of page appearance counts.
    var appearanceSummary: String {
        ProgrammaticTab.allCases
            .map { "\($0.title): \(appearances[$0, default: 0])" }
            .joined(separator: " · ")
    }

    /// Selects the next destination, wrapping from the last destination to the first.
    func selectNext() {
        guard let index = ProgrammaticTab.allCases.firstIndex(of: selection) else { return }
        selection = ProgrammaticTab.allCases[(index + 1) % ProgrammaticTab.allCases.count]
    }

    /// Selects the previous destination, wrapping from the first destination to the last.
    func selectPrevious() {
        guard let index = ProgrammaticTab.allCases.firstIndex(of: selection) else { return }
        let previousIndex = (index - 1 + ProgrammaticTab.allCases.count) % ProgrammaticTab.allCases.count
        selection = ProgrammaticTab.allCases[previousIndex]
    }

    /// Replaces multiple programmatic targets synchronously, leaving profile as the final request.
    func selectProfileRapidly() {
        selection = .activity
        selection = .library
        selection = .profile
    }

    /// Records that a lazily hosted page entered the view hierarchy.
    ///
    /// - Parameter tab: The destination whose page appeared.
    func recordAppearance(of tab: ProgrammaticTab) {
        appearances[tab, default: 0] += 1
    }
}

/// Demonstrates binding-driven navigation, rapid target replacement, and page appearances.
struct ProgrammaticSelectionAndLifecycleDemo: View {
    /// The reference model shared across the outer SwiftUI tree and hosted page roots.
    @State private var model = ProgrammaticDemoModel()

    /// The pager whose pages expose selection controls and lifecycle status.
    var body: some View {
        @Bindable var model = model

        ITabPager(
            tabs: ProgrammaticTab.allCases,
            selection: $model.selection
        ) { tab in
            ProgrammaticPage(tab: tab, model: model)
        } tabTitle: { tab in
            tab.title
        }
        .navigationTitle("Programmatic Selection and Lifecycle")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// One independently hosted page that observes the shared programmatic model directly.
private struct ProgrammaticPage: View {
    /// The stable identity represented by this page.
    let tab: ProgrammaticTab
    /// The shared selection and lifecycle model.
    @Bindable var model: ProgrammaticDemoModel

    /// The page content, observable status, and deterministic navigation controls.
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: tab.systemImage)
                    .font(.system(size: 52))
                    .foregroundStyle(.tint)
                Text(tab.title)
                    .font(.largeTitle.bold())

                DemoControlCard {
                    DemoStatusRow(
                        title: "Selection",
                        value: model.selection.title,
                        accessibilityIdentifier: DemoAccessibility.programmaticSelection
                    )
                    Divider()
                    DemoStatusRow(
                        title: "Appearances",
                        value: model.appearanceSummary,
                        accessibilityIdentifier: DemoAccessibility.programmaticAppearances
                    )
                    Divider()
                    controls
                }
            }
            .padding(24)
        }
        .onAppear {
            model.recordAppearance(of: tab)
        }
    }

    /// The previous, next, and rapid-target controls exposed by every hosted page.
    private var controls: some View {
        VStack(spacing: 10) {
            HStack {
                Button("Previous", action: model.selectPrevious)
                    .buttonStyle(.bordered)
                Button("Next", action: model.selectNext)
                    .buttonStyle(.borderedProminent)
            }
            Button("Rapid target: Profile", action: model.selectProfileRapidly)
            .buttonStyle(.bordered)
        }
    }
}
