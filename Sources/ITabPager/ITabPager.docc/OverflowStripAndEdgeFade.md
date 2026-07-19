# Overflow Strip and Edge Fade

Present more titles than fit while keeping selection visible and clipped edges legible.

## Center the Selected Title

The tab strip is a horizontal `ScrollView`. On first appearance and each selection change, it scrolls the selected identity to the center anchor. This selection-centering rule is independent of the fitted-strip alignment.

When the complete strip is narrower than its viewport, the strip receives the configured horizontal alignment and a minimum width equal to the container. ``ITabPager`` supports leading, center, and trailing fitted layouts through SwiftUI `HorizontalAlignment`.

## Enable Edge Fades

```swift
var style = ITabPagerStyle()
style.showsTabStripEdgeFade = true
style.tabStripEdgeFadeWidth = 44
```

The strip measures tab frames again in the visible viewport coordinate space and unions them into content bounds. A leading gradient appears only when content extends left of the viewport. A trailing gradient appears only when content extends right. Fully visible edges remain opaque.

The rendered width of each gradient is limited to at most half of the current viewport width. Supply a nonnegative ``ITabPagerStyle/tabStripEdgeFadeWidth``; the package does not normalize negative consumer input.

The fade is a visual mask only. It does not change title hit testing, scrolling physics, selection, or content layout.
