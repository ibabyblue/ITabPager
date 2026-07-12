//
//  ITabPagerTests.swift
//  ITabPagerTests
//
//  Created by ibabyblue on 2026/04/30.
//  Copyright © 2026 ibabyblue. All rights reserved.
//

import XCTest
import SwiftUI
@testable import ITabPager

final class LerpTests: XCTestCase {
    func test_lerp_atZero() {
        XCTAssertEqual(lerp(0, 10, 0), 0)
    }
    func test_lerp_atOne() {
        XCTAssertEqual(lerp(0, 10, 1), 10)
    }
    func test_lerp_midpoint() {
        XCTAssertEqual(lerp(0, 10, 0.5), 5)
    }
    func test_lerp_arbitrary() {
        XCTAssertEqual(lerp(100, 200, 0.3), 130, accuracy: 0.001)
    }
    func test_lerp_reverseDirection() {
        XCTAssertEqual(lerp(10, 0, 0.3), 7, accuracy: 0.001)
    }
}

final class SelectionValidationTests: XCTestCase {
    func test_validSelection_returnsItself() {
        let result: Int? = validatedSelection(2, in: [1, 2, 3])
        XCTAssertEqual(result, 2)
    }

    func test_invalidSelection_returnsFirstTab() {
        let result: Int? = validatedSelection(99, in: [1, 2, 3])
        XCTAssertEqual(result, 1)
    }

    func test_emptyTabs_returnsNil() {
        let result: Int? = validatedSelection(1, in: [])
        XCTAssertNil(result)
    }
}

final class TabStripScrollAnchorTests: XCTestCase {
    func test_selectedTabScrollAnchor_isCentered() {
        XCTAssertEqual(selectedTabScrollAnchor(), .center)
    }
}

final class ITabPagerStyleTests: XCTestCase {
    func test_tabStripEdgeFadeDefaultsToOffWithStandardWidth() {
        let style = ITabPagerStyle()

        XCTAssertFalse(style.showsTabStripEdgeFade)
        XCTAssertEqual(style.tabStripEdgeFadeWidth, 44)
    }

    func test_tabStripEdgeFadeCanBeConfigured() {
        var style = ITabPagerStyle()

        style.showsTabStripEdgeFade = true
        style.tabStripEdgeFadeWidth = 32

        XCTAssertTrue(style.showsTabStripEdgeFade)
        XCTAssertEqual(style.tabStripEdgeFadeWidth, 32)
    }
}
