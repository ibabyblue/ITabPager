# Styling and Alignment

Customize tab typography, color interpolation, indicator geometry, spacing, and fitted-strip placement.

## Configure a Style

```swift
var style = ITabPagerStyle()
style.selectedFont = .system(size: 16, weight: .semibold)
style.unselectedFont = .system(size: 16, weight: .regular)
style.selectedColor = .orange
style.unselectedColor = .secondary
style.indicatorColor = .orange
style.indicatorWidthRatio = 0.7
style.indicatorHeight = 2
style.indicatorSpacing = 6
style.tabSpacing = 24
style.showsTabStripEdgeFade = true
style.tabStripEdgeFadeWidth = 40
```

The selected and unselected title layers coexist. Fractional page progress controls the selected layer's opacity, allowing fonts and colors to transition without a discrete state swap.

Indicator height, spacing, tab spacing, and fade width are points. The indicator width ratio is unitless and multiplies the interpolated title width.

## Align a Fitted Strip

```swift
ITabPager(
    tabs: FeedTab.allCases,
    selection: $selection,
    alignment: .center,
    style: style
) { tab in
    Text(tab.rawValue)
} tabTitle: { tab in
    tab.rawValue
}
```

Alignment affects the title stack only when it fits within the viewport. Overflow content remains horizontally scrollable, and every selected title is centered through the same scroll-anchor behavior.
