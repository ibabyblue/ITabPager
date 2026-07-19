# ITabPager

ITabPager is an iOS SwiftUI tab-strip pager with UIKit paging, finger-tracking indicator interpolation, overflow-title centering, optional edge fades, and lazy current-neighbor page hosting.

![iOS 17+](https://img.shields.io/badge/iOS-17%2B-blue)
![Swift 6.2](https://img.shields.io/badge/Swift-6.2%2B-orange)
![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen)
![Version](https://img.shields.io/badge/version-0.2.0-blueviolet)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

## Features

- Continuous title cross-fade and indicator position/width interpolation while paging
- A horizontally scrollable tab strip that centers the selected title
- Optional leading and trailing fades shown only where overflow content is clipped
- Caller-owned, binding-driven selection for taps, swipes, and programmatic navigation
- Lazy UIKit hosting for the current page and its immediate neighbors
- Forwarding of color scheme, Dynamic Type size, and locale to hosted pages
- Configurable fonts, colors, indicator geometry, tab spacing, and fitted-strip alignment
- No third-party Package dependencies

## Requirements

| Requirement | Minimum |
|---|---:|
| iOS | 17.0 |
| Swift | 6.2 |
| Xcode | 26.0 |

## Installation

Add ITabPager with Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/ibabyblue/ITabPager.git", from: "0.2.0")
]
```

Then add the library product to your target:

```swift
.product(name: "ITabPager", package: "ITabPager")
```

## Quick Start

```swift
import ITabPager
import SwiftUI

enum FeedTab: String, CaseIterable, Hashable {
    case recommended = "Recommended"
    case popular = "Popular"
    case latest = "Latest"
}

struct FeedView: View {
    @State private var selection: FeedTab = .recommended

    var body: some View {
        ITabPager(
            tabs: FeedTab.allCases,
            selection: $selection
        ) { tab in
            List(1...30, id: \.self) { row in
                Text("\(tab.rawValue) item \(row)")
            }
            .listStyle(.plain)
        } tabTitle: { tab in
            tab.rawValue
        }
    }
}
```

Use stable, unique `Hashable` tab identities. The binding remains application-owned: taps and completed page gestures update it, and application writes animate the pager to the matching page.

## Behavior at a Glance

| Situation | Behavior |
|---|---|
| `tabs` is empty | Presents no strip or page content |
| One tab | Presents one page and disables horizontal paging |
| Valid selection | Preserved by identity while the supplied collection remains compatible |
| A newly assigned invalid selection | Corrected to the first tab when the selection observer runs |
| Initially invalid or unchanged selection after replacing tabs | The pager displays the first valid page, but callers should keep the binding valid |
| User paging | Publishes continuous fractional progress, then commits the nearest tab identity |
| Programmatic selection | Animates to the target and avoids restarting the same pending animation |
| Hosted pages | Retains the current page and its immediate neighbors |
| Overflow title strip | Centers selection; optional fades appear only at clipped edges |

## Documentation

- [DocC catalog](Sources/ITabPager/ITabPager.docc/ITabPager.md) — selection, interpolation, overflow, styling, navigation, and lifecycle guides
- [Example application](Example/README.md) — four runnable integration scenarios and test instructions
- [Changelog](CHANGELOG.md) — release history and compatibility notes
- Generated API reference is available by building the ITabPager DocC catalog in Xcode.

## Example

Open `Example/ITabPagerDemo.xcodeproj`, select the shared `ITabPagerDemo` scheme, and run an iOS simulator. Regenerate the project after structural changes:

```bash
xcodegen generate --spec Example/project.yml --project Example
```

## License

ITabPager is available under the MIT license. See [LICENSE](LICENSE).
