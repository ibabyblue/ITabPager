//
//  ITabPagerDemoUITests.swift
//  ITabPagerDemoUITests
//
//  Created by OpenAI Codex on 2026/07/19.
//

import XCTest

/// End-to-end coverage for the runnable ITabPager integration catalog.
@MainActor
final class ITabPagerDemoUITests: XCTestCase {
    /// Launches a fresh Example application instance.
    ///
    /// - Returns: The launched application proxy.
    private func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        return app
    }

    /// Verifies every supported integration scenario appears in the catalog.
    func testCatalogShowsAllScenarios() {
        let app = launchApp()

        for scenario in [
            "basicPaging",
            "overflowAndEdgeFade",
            "customStylingAndAlignment",
            "programmaticSelectionAndLifecycle"
        ] {
            XCTAssertTrue(
                app.buttons["demo.scenario.\(scenario)"].waitForExistence(timeout: 2),
                scenario
            )
        }
    }

    /// Verifies a basic title tap updates the observable selected page.
    func testBasicPagingChangesSelectedContent() {
        let app = launchApp()
        openScenario("basicPaging", in: app)

        app.staticTexts["Popular"].firstMatch.tap()

        XCTAssertTrue(waitForStatus(DemoID.basicSelection, toEqual: "Popular", in: app))
    }

    /// Verifies the overflow strip can reveal and select an initially clipped title.
    func testOverflowScenarioSelectsAnInitiallyOffscreenTab() {
        let app = launchApp()
        openScenario("overflowAndEdgeFade", in: app)

        let tabStrip = app.scrollViews.element(boundBy: 0)
        XCTAssertTrue(tabStrip.waitForExistence(timeout: 2))
        let education = app.staticTexts["Education"].firstMatch
        XCTAssertTrue(education.waitForExistence(timeout: 2))
        for _ in 0..<5 {
            let start = tabStrip.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.9))
            let end = tabStrip.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.9))
            start.press(forDuration: 0.05, thenDragTo: end)
        }

        XCTAssertTrue(education.isHittable)
        education.tap()
        XCTAssertTrue(waitForStatus(DemoID.overflowSelection, toEqual: "Education", in: app))
    }

    /// Verifies the custom styling integration remains selectable.
    func testCustomStylingScenarioChangesSelection() {
        let app = launchApp()
        openScenario("customStylingAndAlignment", in: app)

        app.staticTexts["Video"].firstMatch.tap()

        XCTAssertTrue(waitForStatus(DemoID.customSelection, toEqual: "Video", in: app))
    }

    /// Verifies previous, next, rapid target, and lifecycle status are observable.
    func testProgrammaticControlsUpdateSelectionAndLifecycleStatus() {
        let app = launchApp()
        openScenario("programmaticSelectionAndLifecycle", in: app)

        app.buttons["Next"].tap()
        XCTAssertTrue(waitForStatus(DemoID.programmaticSelection, toEqual: "Activity", in: app))

        app.buttons["Previous"].tap()
        XCTAssertTrue(waitForStatus(DemoID.programmaticSelection, toEqual: "Overview", in: app))

        app.buttons["Rapid target: Profile"].tap()
        XCTAssertTrue(waitForStatus(DemoID.programmaticSelection, toEqual: "Profile", in: app))

        let appearances = statusValue(DemoID.programmaticAppearances, in: app)
        XCTAssertTrue(appearances.contains("Overview:"))
        XCTAssertTrue(appearances.contains("Profile:"))
    }

    /// Opens a catalog route by its raw scenario identifier.
    ///
    /// - Parameters:
    ///   - name: The raw scenario name embedded in the catalog identifier.
    ///   - app: The running Example application.
    private func openScenario(_ name: String, in app: XCUIApplication) {
        let row = app.buttons["demo.scenario.\(name)"]
        XCTAssertTrue(row.waitForExistence(timeout: 2), name)
        row.tap()
    }

    /// Waits for an observable status value to equal an expected label.
    ///
    /// - Parameters:
    ///   - identifier: The value's accessibility identifier.
    ///   - expectedValue: The exact label expected from the value.
    ///   - app: The running Example application.
    /// - Returns: `true` when the value matches before the timeout.
    private func waitForStatus(
        _ identifier: String,
        toEqual expectedValue: String,
        in app: XCUIApplication
    ) -> Bool {
        let element = app.staticTexts[identifier]
        guard element.waitForExistence(timeout: 2) else { return false }
        let predicate = NSPredicate(format: "label == %@", expectedValue)
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        return XCTWaiter.wait(for: [expectation], timeout: 3) == .completed
    }

    /// Reads an observable status value by accessibility identifier.
    ///
    /// - Parameters:
    ///   - identifier: The value's accessibility identifier.
    ///   - app: The running Example application.
    /// - Returns: The value's accessibility label.
    private func statusValue(_ identifier: String, in app: XCUIApplication) -> String {
        let element = app.staticTexts[identifier]
        XCTAssertTrue(element.waitForExistence(timeout: 2), identifier)
        return element.label
    }
}

/// Accessibility identifiers mirrored from the application target for UI-test lookup.
private enum DemoID {
    /// The selected value in the basic paging scene.
    static let basicSelection = "demo.basic.selection"
    /// The selected value in the overflow scene.
    static let overflowSelection = "demo.overflow.selection"
    /// The selected value in the custom styling scene.
    static let customSelection = "demo.custom.selection"
    /// The selected value in the programmatic scene.
    static let programmaticSelection = "demo.programmatic.selection"
    /// The page-appearance summary in the programmatic scene.
    static let programmaticAppearances = "demo.programmatic.appearances"
}
