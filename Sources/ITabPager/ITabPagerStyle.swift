//
//  ITabPagerStyle.swift
//  ITabPager
//
//  Created by ibabyblue on 2026/04/30.
//  Copyright © 2026 ibabyblue. All rights reserved.
//

#if canImport(UIKit)
import SwiftUI

public struct ITabPagerStyle {
    public var selectedFont: Font      = .system(size: 17, weight: .bold)
    public var unselectedFont: Font    = .system(size: 17, weight: .regular)
    public var selectedColor: Color    = .primary
    public var unselectedColor: Color  = .secondary
    public var indicatorColor: Color   = .primary
    public var indicatorWidthRatio: CGFloat = 0.5
    public var indicatorHeight: CGFloat = 3
    public var indicatorSpacing: CGFloat = 0
    public var tabSpacing: CGFloat     = 20
    public var showsTabStripEdgeFade: Bool = false
    public var tabStripEdgeFadeWidth: CGFloat = 44

    public init() {}
}
#endif
