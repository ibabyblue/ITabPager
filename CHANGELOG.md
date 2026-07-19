# Changelog

All notable changes to ITabPager are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and releases use semantic versioning.

## [0.2.0] - 2026-07-19

### Added

- Complete English DocC comments for declarations throughout the Package and Example.
- An `ITabPager.docc` catalog covering setup, selection identity, indicator interpolation, overflow fades, styling, programmatic navigation, lazy page lifecycle, and availability.
- An XcodeGen-managed Example application with four focused scenarios, unit tests, UI tests, and a shared scheme.
- Direct README navigation to DocC, Example, and this changelog.

### Changed

- Renamed the runnable integration directory from `demo` to `Example`.
- Reorganized Example code by catalog, shared components, and scenario responsibility.
- Updated installation and consumer examples for release 0.2.0.

### Compatibility

- Package API and runtime behavior are unchanged from 0.1.0.
- iOS 17.0, Swift 6.2, and the dependency-free Package surface are unchanged.

## [0.1.0] - 2026-07-12

### Added

- Configurable overflow tab-strip edge fades with a consumer-defined width.
- Leading and trailing fade visibility driven by measured clipped content.

## [0.0.4] - 2026-06-14

### Changed

- Added standard file headers throughout Package sources.

## [0.0.3] - 2026-05-14

### Changed

- Renamed the Package, module, project, and demo product to the final `ITabPager` naming.
- Updated installation and quick-start examples for the renamed module.

## [0.0.2] - 2026-05-14

### Changed

- Kept local design and implementation planning artifacts outside release commits.
- Added the `I`-prefixed public types and MIT license before the final module rename.

## [0.0.1] - 2026-04-30

### Added

- Initial Swift Package Manager release.
- SwiftUI tab-strip API backed by a UIKit paging scroll view.
- Progress-driven title and indicator interpolation.
- Current-plus-neighbor lazy page hosting and selection helpers.

[0.2.0]: https://github.com/ibabyblue/ITabPager/releases/tag/0.2.0
[0.1.0]: https://github.com/ibabyblue/ITabPager/releases/tag/0.1.0
[0.0.4]: https://github.com/ibabyblue/ITabPager/releases/tag/0.0.4
[0.0.3]: https://github.com/ibabyblue/ITabPager/releases/tag/0.0.3
[0.0.2]: https://github.com/ibabyblue/ITabPager/releases/tag/0.0.2
[0.0.1]: https://github.com/ibabyblue/ITabPager/releases/tag/0.0.1
