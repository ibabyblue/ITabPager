# ``ITabPager``

Present synchronized tab titles and horizontally paged SwiftUI content with continuous UIKit scroll progress.

## Overview

ITabPager combines a SwiftUI tab strip with a UIKit paging controller. The public API remains SwiftUI-native, while `UIScrollView` supplies paging physics and high-frequency progress updates. Title emphasis and the capsule indicator interpolate between measured neighboring tab frames as the user drags.

The caller supplies ordered, unique `Hashable` identities and owns the selection binding. The pager hosts only the current page and its immediate neighbors, forwarding the current color scheme, Dynamic Type size, and locale to those SwiftUI roots.

Start with <doc:QuickStart>, then use the focused guides to understand selection, indicator interpolation, overflow behavior, styling, programmatic navigation, and hosted-page lifecycle. The repository's `Example` application provides runnable integrations.

## Topics

### Essentials

- <doc:QuickStart>
- <doc:SelectionAndTabIdentity>
- <doc:PlatformAndAvailability>

### Paging and Presentation

- <doc:PagingProgressAndIndicator>
- <doc:OverflowStripAndEdgeFade>
- <doc:StylingAndAlignment>

### Navigation and Lifecycle

- <doc:ProgrammaticNavigation>
- <doc:LazyPageLifecycle>

### API

- ``ITabPager``
- ``ITabPagerStyle``
