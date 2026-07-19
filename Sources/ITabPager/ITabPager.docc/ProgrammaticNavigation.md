# Programmatic Navigation

Drive page selection from application state without restarting the same UIKit animation on every SwiftUI update.

## Assign a Valid Selection

```swift
Button("Next") {
    guard let index = FeedTab.allCases.firstIndex(of: selection) else { return }
    selection = FeedTab.allCases[(index + 1) % FeedTab.allCases.count]
}
```

A valid binding change selects its page with `setContentOffset(_:animated:)`. The tab strip independently scrolls its title to the center using a SwiftUI spring.

## Handle Rapid Targets

SwiftUI can call the representable update method repeatedly while UIKit is animating. The controller records a pending target index and does not restart an animation aimed at that same index. If application state changes to a different index, UIKit receives the new target immediately.

UIKit may report the end of a scroll animation after an older animation was interrupted. ITabPager compares the physical content offset with the current binding target and clears pending state only when they match within one point.

## Respect User Ownership

Beginning a drag marks the user as the scroll owner and clears pending programmatic suppression. While dragging or decelerating, representable updates do not force the bound page offset. When the gesture finishes, the nearest page identity becomes selection.
