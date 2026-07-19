# Platform and Availability

Understand the package's iOS and UIKit boundary before integrating it.

## Supported Environment

ITabPager requires iOS 17 or later and Swift 6.2. The Package manifest exposes one `ITabPager` library product and has no external dependencies.

The public view is compiled when UIKit is available. SwiftUI owns the title strip and public composition surface; UIKit owns page scrolling, view-controller containment, and paging callbacks. Callers do not interact with `UIScrollView` or `UIViewController` directly.

## Main-Thread Ownership

SwiftUI rendering, bindings, UIKit controller lifecycle, scroll-view delegate callbacks, and hosted page mutations are UI work. Use ITabPager from normal SwiftUI main-actor contexts and keep selection mutations consistent with application UI isolation.

## Unsupported Platforms

The Package does not declare macOS, tvOS, watchOS, or visionOS support. It does not provide a non-UIKit pager implementation or a compatibility fallback for those platforms.
