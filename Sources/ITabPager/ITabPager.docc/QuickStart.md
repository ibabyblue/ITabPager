# Quick Start

Create a pager from stable identities, a caller-owned selection binding, page content, and tab titles.

## Define Tab Identity

```swift
import ITabPager
import SwiftUI

enum FeedTab: String, CaseIterable, Hashable {
    case recommended = "Recommended"
    case popular = "Popular"
    case latest = "Latest"
}
```

Use unique identities and preserve them while the corresponding destination remains conceptually the same.

## Present Pages

```swift
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

Tapping a title changes `selection` and animates the page. Swiping publishes continuous progress and writes the nearest tab identity after paging finishes. Assigning a valid identity to the binding navigates programmatically.

An empty tab array presents no content. One tab presents one page and disables horizontal scrolling.
