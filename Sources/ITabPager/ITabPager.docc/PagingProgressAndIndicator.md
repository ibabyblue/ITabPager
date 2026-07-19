# Paging Progress and Indicator Interpolation

Understand how physical UIKit scrolling drives SwiftUI title emphasis and indicator geometry.

## Follow Fractional Page Progress

The paging controller divides the horizontal content offset by the current page width. It clamps that fractional index to the available page range and writes it into SwiftUI state from `scrollViewDidScroll`.

For tab index `i`, the selected-layer opacity is calculated as `max(0, 1 - abs(progress - i))`. This makes the departing title fade out while the arriving title fades in. A hidden selected-font title reserves stable width so typography changes do not resize the strip during the transition.

## Interpolate the Indicator

The strip measures every title frame in its complete coordinate space. For a progress value between two pages, ITabPager linearly interpolates their widths and horizontal centers. ``ITabPagerStyle/indicatorWidthRatio`` scales the interpolated width before the capsule is positioned beneath the result.

Physical scroll progress is already continuous, so it does not receive an additional SwiftUI animation. A spring animation is used when the first usable frame measurements arrive and when selection centering changes.

## Account for Layout

The indicator reserves ``ITabPagerStyle/indicatorHeight`` plus ``ITabPagerStyle/indicatorSpacing`` below each title. Values are consumer supplied; use nonnegative point dimensions and a nonnegative width ratio for a visible, predictable result.
