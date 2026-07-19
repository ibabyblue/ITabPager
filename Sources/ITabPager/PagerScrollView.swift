//
//  PagerScrollView.swift
//  ITabPager
//
//  Created by ibabyblue on 2026/04/30.
//  Copyright © 2026 ibabyblue. All rights reserved.
//

#if canImport(UIKit)
import SwiftUI
import UIKit

// MARK: - PagerScrollView

/// A SwiftUI representable that hosts paged content in a UIKit scroll-view controller.
struct PagerScrollView<Tab: Hashable, Content: View>: UIViewControllerRepresentable {

    /// The ordered tab identities represented by pages.
    let tabs: [Tab]
    /// The caller-owned selected tab binding.
    @Binding var selection: Tab
    /// The fractional page index written by scroll-view progress updates.
    @Binding var progress: CGFloat
    /// The SwiftUI builder used to create hosted page content.
    let content: (Tab) -> Content

    /// The current SwiftUI color scheme forwarded to hosted roots.
    @Environment(\.colorScheme) private var colorScheme
    /// The current Dynamic Type size forwarded to hosted roots.
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    /// The current locale forwarded to hosted roots.
    @Environment(\.locale) private var locale

    /// Creates the UIKit paging controller used by the representable.
    ///
    /// - Parameter context: The current representable context.
    /// - Returns: A paging controller initialized with the current bindings and builder.
    func makeUIViewController(context: Context) -> PagerViewController<Tab, Content> {
        PagerViewController(
            tabs: tabs,
            selectionBinding: $selection,
            progressBinding: $progress,
            content: content
        )
    }

    /// Reconciles SwiftUI inputs and environment values with the existing paging controller.
    ///
    /// - Parameters:
    ///   - vc: The controller previously created by ``makeUIViewController(context:)``.
    ///   - context: The current representable context.
    func updateUIViewController(_ vc: PagerViewController<Tab, Content>, context: Context) {
        vc.update(
            tabs: tabs,
            selectionBinding: $selection,
            progressBinding: $progress,
            content: content,
            colorScheme: colorScheme,
            dynamicTypeSize: dynamicTypeSize,
            locale: locale
        )
    }
}

// MARK: - PagerViewController

/// A paging controller that keeps only the current page and adjacent pages hosted.
final class PagerViewController<Tab: Hashable, Content: View>: UIViewController, UIScrollViewDelegate {

    // MARK: Properties

    /// The paging scroll view owned by the controller.
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.bounces = true
        sv.clipsToBounds = true
        sv.backgroundColor = .clear
        return sv
    }()

    /// The current ordered tab identities.
    private var tabs: [Tab]
    /// The current caller-owned selection binding.
    private var selectionBinding: Binding<Tab>
    /// The binding that receives fractional page progress.
    private var progressBinding: Binding<CGFloat>
    /// The current SwiftUI page-content builder.
    private var content: (Tab) -> Content
    /// The color scheme applied to hosted SwiftUI roots.
    private var colorScheme: ColorScheme = .light
    /// The Dynamic Type size applied to hosted SwiftUI roots.
    private var dynamicTypeSize: DynamicTypeSize = .large
    /// The locale applied to hosted SwiftUI roots.
    private var locale: Locale = .current

    /// Hosted pages keyed by their current integer page index.
    private var hostingControllers: [Int: UIHostingController<AnyView>] = [:]
    /// Whether a user drag or deceleration currently owns the scroll position.
    private(set) var isUserScrolling = false
    /// Whether layout is synchronously adjusting content offset after a size change.
    private var isResizing = false
    /// The programmatic target whose animated scroll should not be restarted by SwiftUI updates.
    private var pendingTargetIndex: Int? = nil

    // MARK: Init

    /// Creates a paging controller from the initial tab data, bindings, and content builder.
    ///
    /// - Parameters:
    ///   - tabs: The ordered identities represented by pages.
    ///   - selectionBinding: The caller-owned selected-tab binding.
    ///   - progressBinding: The binding that receives fractional page progress.
    ///   - content: The SwiftUI builder used to create page roots.
    init(
        tabs: [Tab],
        selectionBinding: Binding<Tab>,
        progressBinding: Binding<CGFloat>,
        content: @escaping (Tab) -> Content
    ) {
        self.tabs = tabs
        self.selectionBinding = selectionBinding
        self.progressBinding = progressBinding
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }

    /// Storyboard and archive construction are unsupported for this programmatic controller.
    ///
    /// - Parameter coder: The decoder supplied by UIKit.
    /// - Returns: This initializer always terminates instead of returning an instance.
    required init?(coder: NSCoder) { fatalError() }

    // MARK: Lifecycle

    /// Installs the paging scroll view and connects its delegate.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        scrollView.delegate = self
        view.addSubview(scrollView)
    }

    /// Sizes the scroll view and hosted pages, preserving the selected page across layout changes.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bounds = view.bounds
        guard bounds.width > 0 else { return }
        scrollView.frame = bounds
        updateContentSize()
        updateAllPageFrames()
        if !isUserScrolling {
            let index = clampedIndex(for: selectionBinding.wrappedValue)
            isResizing = true
            scrollView.contentOffset = CGPoint(x: CGFloat(index) * bounds.width, y: 0)
            isResizing = false
        }
        updateVisiblePages()
    }

    // MARK: Public Update

    /// Reconciles tabs, bindings, content, and SwiftUI environment values.
    ///
    /// Programmatic selection changes animate to the target unless a user gesture owns scrolling
    /// or the same target is already pending. Visible pages refresh after the target is reached.
    ///
    /// - Parameters:
    ///   - tabs: The current ordered tab identities.
    ///   - selectionBinding: The current caller-owned selected-tab binding.
    ///   - progressBinding: The current fractional-progress binding.
    ///   - content: The current page-content builder.
    ///   - colorScheme: The color scheme forwarded to hosted content.
    ///   - dynamicTypeSize: The Dynamic Type size forwarded to hosted content.
    ///   - locale: The locale forwarded to hosted content.
    func update(
        tabs: [Tab],
        selectionBinding: Binding<Tab>,
        progressBinding: Binding<CGFloat>,
        content: @escaping (Tab) -> Content,
        colorScheme: ColorScheme,
        dynamicTypeSize: DynamicTypeSize,
        locale: Locale
    ) {
        self.tabs = tabs
        self.selectionBinding = selectionBinding
        self.progressBinding = progressBinding
        self.content = content
        self.colorScheme = colorScheme
        self.dynamicTypeSize = dynamicTypeSize
        self.locale = locale

        scrollView.isScrollEnabled = tabs.count > 1
        updateContentSize()
        updateAllPageFrames()

        let targetIndex = clampedIndex(for: selectionBinding.wrappedValue)
        let targetX = CGFloat(targetIndex) * scrollView.bounds.width

        if !isUserScrolling {
            if abs(scrollView.contentOffset.x - targetX) > 1 && pendingTargetIndex != targetIndex {
                pendingTargetIndex = targetIndex
                scrollView.setContentOffset(CGPoint(x: targetX, y: 0), animated: true)
            }
        }

        // Compare the physical offset so interrupted animations cannot clear a pending target early.
        let notAtTarget = abs(scrollView.contentOffset.x - targetX) > 1
        if !isUserScrolling && !scrollView.isDecelerating && !notAtTarget {
            updateVisiblePages()
        }
    }

    // MARK: UIScrollViewDelegate

    /// Marks the start of user-controlled paging and cancels programmatic target suppression.
    ///
    /// - Parameter scrollView: The paging scroll view beginning its drag.
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUserScrolling = true
        pendingTargetIndex = nil
    }

    /// Commits selection immediately when a drag ends without deceleration.
    ///
    /// - Parameters:
    ///   - scrollView: The paging scroll view ending its drag.
    ///   - decelerate: Whether UIKit will continue scrolling after the drag.
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isUserScrolling = false
            snapSelection()
        }
    }

    /// Publishes fractional page progress and maintains the current-neighbor hosting window.
    ///
    /// - Parameter scrollView: The paging scroll view whose content offset changed.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isResizing else { return }
        let pageWidth = scrollView.bounds.width
        guard pageWidth > 0 else { return }
        let rawProgress = scrollView.contentOffset.x / pageWidth
        let clampedProgress = max(0, min(rawProgress, CGFloat(tabs.count - 1)))
        progressBinding.wrappedValue = clampedProgress
        loadUnloadPages()
    }

    /// Commits the nearest page after deceleration and refreshes the hosting window.
    ///
    /// - Parameter scrollView: The paging scroll view that stopped decelerating.
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isUserScrolling = false
        snapSelection()
        updateVisiblePages()
    }

    /// Clears a programmatic target only after UIKit physically reaches the current selection.
    ///
    /// UIKit can deliver this callback for an interrupted animation, so an offset outside the
    /// tolerance leaves the newer target pending.
    ///
    /// - Parameter scrollView: The paging scroll view whose animation ended or was interrupted.
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isUserScrolling = false
        // An interrupted callback must not clear a newer animation that has not reached its target.
        let currentIndex = clampedIndex(for: selectionBinding.wrappedValue)
        let targetX = CGFloat(currentIndex) * scrollView.bounds.width
        if abs(scrollView.contentOffset.x - targetX) <= 1 {
            pendingTargetIndex = nil
        }
        updateVisiblePages()
    }

    // MARK: Private

    /// Updates the scrollable content size from the current page count and viewport bounds.
    private func updateContentSize() {
        let pageWidth = scrollView.bounds.width
        scrollView.contentSize = CGSize(
            width: pageWidth * CGFloat(tabs.count),
            height: scrollView.bounds.height
        )
    }

    /// Repositions every currently hosted page after a viewport-size change.
    private func updateAllPageFrames() {
        let pageWidth = scrollView.bounds.width
        let pageHeight = scrollView.bounds.height
        for (index, vc) in hostingControllers {
            vc.view.frame = CGRect(
                x: CGFloat(index) * pageWidth,
                y: 0,
                width: pageWidth,
                height: pageHeight
            )
        }
    }

    /// Loads missing pages and unloads pages outside the current-plus-neighbor window while scrolling.
    private func loadUnloadPages() {
        let pageWidth = scrollView.bounds.width
        guard pageWidth > 0, !tabs.isEmpty else { return }
        let currentIndex = Int(round(scrollView.contentOffset.x / pageWidth))
            .clamped(to: 0...(tabs.count - 1))
        let lo = max(0, currentIndex - 1)
        let hi = min(tabs.count - 1, currentIndex + 1)
        let pageHeight = scrollView.bounds.height

        // Unload pages outside the current-neighbor window.
        for index in Array(hostingControllers.keys) where index < lo || index > hi {
            let vc = hostingControllers[index]!
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
            hostingControllers.removeValue(forKey: index)
        }

        // Load new pages with the latest forwarded environment.
        for index in lo...hi where hostingControllers[index] == nil {
            let tab = tabs[index]
            let rootView = AnyView(
                content(tab)
                    .environment(\.colorScheme, colorScheme)
                    .environment(\.dynamicTypeSize, dynamicTypeSize)
                    .environment(\.locale, locale)
            )
            let vc = UIHostingController(rootView: rootView)
            vc.view.backgroundColor = .clear
            addChild(vc)
            scrollView.addSubview(vc.view)
            vc.view.frame = CGRect(x: CGFloat(index) * pageWidth, y: 0, width: pageWidth, height: pageHeight)
            vc.didMove(toParent: self)
            hostingControllers[index] = vc
        }
    }

    /// Rebuilds or creates every page in the current-plus-neighbor window.
    private func updateVisiblePages() {
        let pageWidth = scrollView.bounds.width
        guard pageWidth > 0, !tabs.isEmpty else { return }

        let currentIndex = Int(round(scrollView.contentOffset.x / pageWidth))
            .clamped(to: 0...(tabs.count - 1))
        let lo = max(0, currentIndex - 1)
        let hi = min(tabs.count - 1, currentIndex + 1)
        let pageHeight = scrollView.bounds.height

        // Unload pages outside the current-neighbor window.
        for index in Array(hostingControllers.keys) where index < lo || index > hi {
            let vc = hostingControllers[index]!
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
            hostingControllers.removeValue(forKey: index)
        }

        // Load or update pages inside the window.
        for index in lo...hi {
            let tab = tabs[index]
            let rootView = AnyView(
                content(tab)
                    .environment(\.colorScheme, colorScheme)
                    .environment(\.dynamicTypeSize, dynamicTypeSize)
                    .environment(\.locale, locale)
            )
            if let vc = hostingControllers[index] {
                vc.rootView = rootView
                vc.view.frame = CGRect(x: CGFloat(index) * pageWidth, y: 0, width: pageWidth, height: pageHeight)
            } else {
                let vc = UIHostingController(rootView: rootView)
                vc.view.backgroundColor = .clear
                addChild(vc)
                scrollView.addSubview(vc.view)
                vc.view.frame = CGRect(x: CGFloat(index) * pageWidth, y: 0, width: pageWidth, height: pageHeight)
                vc.didMove(toParent: self)
                hostingControllers[index] = vc
            }
        }
    }

    /// Rounds the physical offset to a page and writes its identity into the selection binding.
    private func snapSelection() {
        let pageWidth = scrollView.bounds.width
        guard pageWidth > 0 else { return }
        let index = Int(round(scrollView.contentOffset.x / pageWidth))
            .clamped(to: 0...(tabs.count - 1))
        selectionBinding.wrappedValue = tabs[index]
    }

    /// Resolves a tab identity to an index that is valid for the current page collection.
    ///
    /// - Parameter tab: The candidate tab identity.
    /// - Returns: Its index when present, or the first valid index when absent.
    private func clampedIndex(for tab: Tab) -> Int {
        (tabs.firstIndex(of: tab) ?? 0).clamped(to: 0...(max(0, tabs.count - 1)))
    }
}

// MARK: - Comparable clamped helper

/// Closed-range clamping used by page-index and scroll-position calculations.
private extension Comparable {
    /// Limits this value to the supplied closed range.
    ///
    /// - Parameter range: The inclusive lower and upper bounds.
    /// - Returns: This value when in range, otherwise the nearest bound.
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
#endif
