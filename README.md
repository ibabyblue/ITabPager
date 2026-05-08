# iTabPager

A tab-strip pager component for iOS 17+. UIScrollView paging core, SwiftUI public API, zero third-party dependencies.

## Requirements

- iOS 17+
- Swift 6.2+
- Xcode 16+

## Installation

### Swift Package Manager

In Xcode choose **File → Add Package Dependencies**, enter the repository URL, or add it directly to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ibabyblue/iTabPager", from: "0.0.1")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "iTabPager", package: "iTabPager")
        ]
    )
]
```

## Quick Start

```swift
import iTabPager

enum Tab: String, CaseIterable {
    case recommended = "推荐"
    case hot         = "热门"
    case latest      = "最新"
}

struct ContentView: View {
    @State private var selection: Tab = .recommended

    var body: some View {
        TabPager(
            tabs: Tab.allCases,
            selection: $selection,
            content: { tab in
                List(0..<30, id: \.self) { i in
                    Text("\(tab.rawValue) · \(i + 1)")
                }
                .listStyle(.plain)
            },
            tabTitle: { $0.rawValue }
        )
    }
}
```

## Custom Style

```swift
TabPager(
    tabs: tabs,
    selection: $selection,
    alignment: .leading,
    style: TabPagerStyle(
        selectedFont:        .system(size: 16, weight: .bold),
        unselectedFont:      .system(size: 16, weight: .regular),
        selectedColor:       .primary,
        unselectedColor:     .secondary,
        indicatorColor:      .blue,
        indicatorWidthRatio: 0.6,
        indicatorHeight:     3,
        indicatorSpacing:    4,
        tabSpacing:          20
    ),
    content: { tab in MyPageView(tab: tab) },
    tabTitle: { tab in tab.title }
)
```

## API Reference

### TabPager

```swift
public struct TabPager<Tab: Hashable, Content: View>: View {
    public init(
        tabs: [Tab],
        selection: Binding<Tab>,
        alignment: HorizontalAlignment = .leading,
        style: TabPagerStyle = .init(),
        @ViewBuilder content: @escaping (Tab) -> Content,
        tabTitle: @escaping (Tab) -> String
    )
}
```

### TabPagerStyle

| Property | Type | Default | Description |
|---|---|---|---|
| `selectedFont` | `Font` | `.system(size: 17, weight: .bold)` | Selected tab font |
| `unselectedFont` | `Font` | `.system(size: 17, weight: .regular)` | Unselected tab font |
| `selectedColor` | `Color` | `.primary` | Selected tab text color |
| `unselectedColor` | `Color` | `.secondary` | Unselected tab text color |
| `indicatorColor` | `Color` | `.primary` | Indicator bar color |
| `indicatorWidthRatio` | `CGFloat` | `0.5` | Indicator width as a fraction of the tab label width |
| `indicatorHeight` | `CGFloat` | `3` | Indicator bar height |
| `indicatorSpacing` | `CGFloat` | `0` | Gap between the tab label and the indicator bar |
| `tabSpacing` | `CGFloat` | `20` | Horizontal spacing between tab labels |

## Edge-Case Behavior

| Scenario | Behavior |
|---|---|
| `tabs` is empty | Renders nothing, no crash |
| `tabs.count == 1` | Paging disabled, single page shown |
| `selection` not in `tabs` | Corrected to `tabs.first` automatically |
| `tabs` replaced at runtime | Pages reload, selection snaps to nearest valid tab |
| Rapid tab taps | Each tap interrupts the previous animation and starts a new one immediately |

## Demo

Open `demo/iTabPagerDemo.xcodeproj`, select a simulator and run. Includes:

- **Basic** — three-tab pager with a plain list
- **Overflow** — fifteen tabs that overflow the strip, auto-scrolls to keep the selected tab visible
- **Custom Style** — custom fonts, colors, and indicator appearance

## Design Notes

- Core: `UIScrollView` with `isPagingEnabled = true` wrapped in `UIViewControllerRepresentable`. Each page is a `UIHostingController`; only the current page and its immediate neighbors are kept in memory.
- Tab colors and fonts cross-fade continuously with scroll progress — the selected layer fades in as the adjacent page scrolls into view, matching the indicator in real time.
- The indicator interpolates position and width between neighboring tab frames, driven by `scrollViewDidScroll`, producing smooth finger-tracking animation.
- Programmatic tab switches use `setContentOffset(animated:)`. A `pendingTargetIndex` guard prevents redundant animation restarts from the SwiftUI re-render loop; the guard is cleared only when the scroll view physically reaches the target offset, making it robust against UIKit cancelling intermediate animations.
- The public API is entirely SwiftUI; callers have no exposure to UIKit.

## Out of Scope

- Vertical tab strips
- Drag-to-reorder tabs
- macOS / tvOS
