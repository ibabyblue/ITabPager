//
//  ITabPagerStyle.swift
//  ITabPager
//
//  Created by ibabyblue on 2026/04/30.
//  Copyright © 2026 ibabyblue. All rights reserved.
//

#if canImport(UIKit)
import SwiftUI

/// Visual and layout values used by an ``ITabPager`` tab strip and indicator.
public struct ITabPagerStyle {
    /// The font of the fully selected tab title. The default is a 17-point bold system font.
    public var selectedFont: Font      = .system(size: 17, weight: .bold)
    /// The font of an unselected tab title. The default is a 17-point regular system font.
    public var unselectedFont: Font    = .system(size: 17, weight: .regular)
    /// The foreground color of the fully selected title. The default is `Color.primary`.
    public var selectedColor: Color    = .primary
    /// The foreground color beneath the selected title layer. The default is `Color.secondary`.
    public var unselectedColor: Color  = .secondary
    /// The indicator capsule color. The default is `Color.primary`.
    public var indicatorColor: Color   = .primary
    /// The indicator width as a multiplier of the interpolated tab-title width. The default is `0.5`.
    public var indicatorWidthRatio: CGFloat = 0.5
    /// The indicator height, in points. The default is `3`.
    public var indicatorHeight: CGFloat = 3
    /// The gap between the title and indicator, in points. The default is `0`.
    public var indicatorSpacing: CGFloat = 0
    /// The horizontal spacing between neighboring tab titles, in points. The default is `20`.
    public var tabSpacing: CGFloat     = 20
    /// Whether clipped overflow content receives leading and trailing fade masks. The default is `false`.
    public var showsTabStripEdgeFade: Bool = false
    /// The requested width of each edge fade, in points. The default is `44`.
    ///
    /// Rendering limits this value to at most half of the visible strip width.
    public var tabStripEdgeFadeWidth: CGFloat = 44

    /// Creates a style with the package defaults.
    public init() {}
}
#endif
