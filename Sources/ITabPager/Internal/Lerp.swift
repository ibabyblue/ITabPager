//
//  Lerp.swift
//  ITabPager
//
//  Created by ibabyblue on 2026/04/30.
//  Copyright © 2026 ibabyblue. All rights reserved.
//

import CoreGraphics

/// Linearly interpolates between two scalar values.
///
/// - Parameters:
///   - a: The value returned when `t` is `0`.
///   - b: The value returned when `t` is `1`.
///   - t: The interpolation fraction. Values outside `0...1` extrapolate.
/// - Returns: `a + (b - a) * t`.
func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
    a + (b - a) * t
}
