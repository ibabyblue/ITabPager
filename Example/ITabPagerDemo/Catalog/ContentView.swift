//
//  ContentView.swift
//  ITabPagerDemo
//
//  Created by ibabyblue on 2026/05/08.
//  Copyright © 2026 ibabyblue. All rights reserved.
//

import SwiftUI

/// The section-free scenario catalog and navigation router for the Example application.
struct ContentView: View {
    /// A navigation stack that lists and routes every supported integration scenario.
    var body: some View {
        NavigationStack {
            List(DemoScenario.allCases) { scenario in
                NavigationLink(value: scenario) {
                    DemoCatalogLabel(scenario: scenario)
                }
                .accessibilityIdentifier(scenario.accessibilityIdentifier)
            }
            .navigationTitle("ITabPager")
            .navigationDestination(for: DemoScenario.self) { scenario in
                switch scenario {
                case .basicPaging:
                    BasicPagingDemo()
                case .overflowAndEdgeFade:
                    OverflowAndEdgeFadeDemo()
                case .customStylingAndAlignment:
                    CustomStylingAndAlignmentDemo()
                case .programmaticSelectionAndLifecycle:
                    ProgrammaticSelectionAndLifecycleDemo()
                }
            }
        }
    }
}
