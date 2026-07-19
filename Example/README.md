# ITabPager Example

This application is the runnable integration reference for ITabPager. It consumes the repository through a local Swift package dependency and keeps scenario code outside Package products and targets.

## Run

1. Open `ITabPagerDemo.xcodeproj` in Xcode.
2. Select the shared `ITabPagerDemo` scheme.
3. Run an iOS 17 or newer simulator.

## Scenarios

| Scenario | Demonstrates |
|---|---|
| Basic Paging | Default titles, tab taps, page swipes, lists, and caller-owned selection |
| Overflow and Edge Fade | Fifteen titles, selected-title centering, and clipped-edge fades |
| Custom Styling and Alignment | Fonts, colors, indicator geometry, spacing, and fitted center alignment |
| Programmatic Selection and Lifecycle | Previous, next, rapid targets, and observable lazy page appearances |

All presentation copy and test fixtures are local. The Example does not make network requests.

## Tests

The shared scheme contains catalog unit tests and end-to-end UI tests:

```bash
xcodebuild -quiet test \
  -project Example/ITabPagerDemo.xcodeproj \
  -scheme ITabPagerDemo \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  CODE_SIGNING_ALLOWED=NO
```

Tests cover catalog wiring, metadata, tab selection, overflow navigation, custom styling integration, programmatic navigation, and lifecycle status.

## Regenerate the Project

`project.yml` is the source of truth for the Xcode project:

```bash
xcodegen generate --spec Example/project.yml --project Example
```

Commit the regenerated project together with `project.yml` after structural changes.
