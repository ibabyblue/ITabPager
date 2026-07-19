//
//  ITabPagerDemoTests.swift
//  ITabPagerDemoTests
//
//  Created by OpenAI Codex on 2026/07/19.
//

import XCTest
@testable import ITabPagerDemo

/// Deterministic unit coverage for the Example catalog and scenario identities.
@MainActor
final class ITabPagerDemoTests: XCTestCase {
    /// Verifies the catalog exposes the four documented scenarios in discovery order.
    func testCatalogContainsExpectedScenariosInOrder() {
        XCTAssertEqual(
            DemoScenario.allCases,
            [
                .basicPaging,
                .overflowAndEdgeFade,
                .customStylingAndAlignment,
                .programmaticSelectionAndLifecycle
            ]
        )
    }

    /// Verifies every catalog route has complete consumer-facing presentation metadata.
    func testEveryScenarioHasCompletePresentationMetadata() {
        for scenario in DemoScenario.allCases {
            XCTAssertFalse(scenario.title.isEmpty)
            XCTAssertFalse(scenario.summary.isEmpty)
            XCTAssertFalse(scenario.systemImage.isEmpty)
            XCTAssertTrue(scenario.accessibilityIdentifier.hasPrefix("demo.scenario."))
        }
    }

    /// Verifies each catalog route exposes a unique accessibility identifier.
    func testScenarioAccessibilityIdentifiersAreUnique() {
        let identifiers = DemoScenario.allCases.map(\.accessibilityIdentifier)

        XCTAssertEqual(Set(identifiers).count, identifiers.count)
    }

    /// Verifies programmatic-navigation fixtures use stable, unique identities.
    func testProgrammaticTabsHaveStableUniqueIdentities() {
        let tabs = ProgrammaticTab.allCases

        XCTAssertEqual(tabs, [.overview, .activity, .library, .profile])
        XCTAssertEqual(Set(tabs).count, tabs.count)
    }
}
