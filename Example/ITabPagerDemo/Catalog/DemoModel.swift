//
//  DemoModel.swift
//  ITabPagerDemo
//
//  Created by OpenAI Codex on 2026/07/19.
//  Copyright © 2026 ibabyblue. All rights reserved.
//

import Foundation

/// A runnable ITabPager integration available from the Example catalog.
enum DemoScenario: String, CaseIterable, Identifiable {
    /// Default title selection and horizontal page gestures.
    case basicPaging
    /// A long title strip with automatic centering and clipped-edge fades.
    case overflowAndEdgeFade
    /// Custom typography, colors, indicator geometry, spacing, and fitted alignment.
    case customStylingAndAlignment
    /// Binding-driven navigation and observable page appearance behavior.
    case programmaticSelectionAndLifecycle

    /// The stable identity of this catalog scenario.
    var id: Self { self }

    /// The user-facing catalog and navigation title.
    var title: String {
        switch self {
        case .basicPaging: "Basic Paging"
        case .overflowAndEdgeFade: "Overflow and Edge Fade"
        case .customStylingAndAlignment: "Custom Styling and Alignment"
        case .programmaticSelectionAndLifecycle: "Programmatic Selection and Lifecycle"
        }
    }

    /// A concise description of the scenario's integration focus.
    var summary: String {
        switch self {
        case .basicPaging: "Tap and swipe between three list-backed pages."
        case .overflowAndEdgeFade: "Center selected overflow tabs and fade clipped strip edges."
        case .customStylingAndAlignment: "Customize fonts, colors, indicator geometry, spacing, and alignment."
        case .programmaticSelectionAndLifecycle: "Drive selection from controls and observe page appearances."
        }
    }

    /// The SF Symbols name displayed by the catalog row.
    var systemImage: String {
        switch self {
        case .basicPaging: "rectangle.3.group"
        case .overflowAndEdgeFade: "arrow.left.and.right"
        case .customStylingAndAlignment: "paintpalette"
        case .programmaticSelectionAndLifecycle: "arrow.triangle.2.circlepath"
        }
    }

    /// The stable UI-test identifier assigned to this catalog route.
    var accessibilityIdentifier: String {
        "demo.scenario.\(rawValue)"
    }
}

/// Stable accessibility identifiers shared by Example scenes and UI tests.
enum DemoAccessibility {
    /// The selected value in the basic paging scene.
    static let basicSelection = "demo.basic.selection"
    /// The selected value in the overflow scene.
    static let overflowSelection = "demo.overflow.selection"
    /// The selected value in the custom styling scene.
    static let customSelection = "demo.custom.selection"
    /// The selected value in the programmatic navigation scene.
    static let programmaticSelection = "demo.programmatic.selection"
    /// The page-appearance summary in the programmatic navigation scene.
    static let programmaticAppearances = "demo.programmatic.appearances"
}
