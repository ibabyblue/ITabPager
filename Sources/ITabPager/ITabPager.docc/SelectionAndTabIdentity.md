# Selection and Tab Identity

Keep application-owned selection consistent with the ordered identities supplied to the pager.

## Treat Hashable Values as Stable Identity

The pager uses each `Hashable` tab value to identify its title and locate its page index. Supply unique values; repeated identities are not deduplicated and are unsuitable for SwiftUI `ForEach` identity.

The binding remains the source of truth for application navigation:

- Tapping a title writes that tab into the binding.
- Completing a user page gesture rounds the physical offset and writes the nearest tab.
- Assigning a valid tab from application code animates to its page.

## Keep the Binding Valid

When a new selection value is assigned and it is absent from a nonempty `tabs` collection, the SwiftUI selection observer replaces it with the first tab. The UIKit controller also clamps an unknown identity to the first page for display.

An initially invalid binding, or an unchanged binding made invalid by replacing `tabs`, is not guaranteed to receive an automatic write-back because the selection value itself did not change. The displayed page still clamps to index zero. Keep `selection` valid before presenting or replacing the collection:

```swift
func replaceTabs(_ newTabs: [FeedTab]) {
    if !newTabs.contains(selection), let first = newTabs.first {
        selection = first
    }
    tabs = newTabs
}
```

If the collection is empty, ``ITabPager`` presents `EmptyView` and does not mutate selection.

## Preserve Ordering Semantics

Page offsets, lazy controller storage, and indicator progress are index-based. Treat runtime collection replacement as an application-coordinated transition: update selection deliberately and avoid changing order during an active drag or programmatic page animation.
