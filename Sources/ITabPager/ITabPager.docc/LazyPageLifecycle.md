# Lazy Page Lifecycle and Environment Updates

Plan page state and side effects around the current-plus-neighbor hosting window.

## Current and Adjacent Pages

The UIKit controller hosts the page nearest the physical content offset plus at most one page on each side. Pages outside that window are removed from their parent controller and view hierarchy. Missing pages are created as the window moves.

This is view-controller lazy loading, not model caching. If a page owns ephemeral SwiftUI state, that state can be recreated after the page leaves and later re-enters the hosting window. Keep durable feature state in an application-owned model when it must survive unloading.

## Forwarded Environment Values

Each hosted root explicitly receives the current:

- SwiftUI color scheme
- Dynamic Type size
- Locale

When those values or the content builder change, visible and neighboring roots are rebuilt with the latest values after scrolling is settled. Do not assume every custom environment value is automatically forwarded across the UIKit hosting boundary; pass feature dependencies through the page builder or an application-owned model.

## Layout Changes

When controller bounds change, the scroll content size and all hosted page frames update. Outside active user scrolling, the controller synchronously restores the selected page offset while suppressing that resize adjustment from fractional progress handling.
