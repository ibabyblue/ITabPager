//
//  ITabPager.swift
//  ITabPager
//
//  Created by ibabyblue on 2026/04/30.
//  Copyright © 2026 ibabyblue. All rights reserved.
//

#if canImport(UIKit)
import SwiftUI

// MARK: - ITabPager

/// A horizontally paged SwiftUI container with a synchronized, scrollable tab strip.
///
/// The caller owns `selection`. User taps and completed page gestures write the selected tab
/// back to the binding, while programmatic binding changes animate to the corresponding page.
public struct ITabPager<Tab: Hashable, Content: View>: View {

    // MARK: Public Properties

    /// The ordered tab identities represented by the strip and page controller.
    let tabs: [Tab]
    /// The caller-owned selected tab identity.
    @Binding var selection: Tab
    /// The horizontal alignment used when the complete strip is narrower than its container.
    var alignment: HorizontalAlignment
    /// The fonts, colors, indicator geometry, spacing, and edge-fade configuration.
    var style: ITabPagerStyle
    /// The builder used to create a page for a tab identity.
    let content: (Tab) -> Content
    /// The builder used to resolve the visible title of a tab identity.
    let tabTitle: (Tab) -> String

    // MARK: Private State

    /// The fractional page index reported by the UIKit paging controller.
    @State private var progress: CGFloat = 0
    /// Tab-label frames measured in the complete strip coordinate space.
    @State private var tabFrames: [AnyHashable: CGRect] = [:]
    /// Tab-label frames measured in the visible scroll-viewport coordinate space.
    @State private var tabViewportFrames: [AnyHashable: CGRect] = [:]
    /// The current visible width of the tab-strip container, in points.
    @State private var containerWidth: CGFloat = 0
    /// Whether the strip has received its first nonempty set of tab frames.
    @State private var isInitialized = false

    // MARK: Init

    /// Creates a synchronized tab strip and horizontally paged content container.
    ///
    /// - Parameters:
    ///   - tabs: The ordered, stable tab identities to display.
    ///   - selection: A caller-owned binding to the selected identity.
    ///   - alignment: The strip alignment used when all tabs fit. The default is `.leading`.
    ///   - style: The visual and layout configuration. The default is ``ITabPagerStyle/init()``.
    ///   - content: A SwiftUI builder that creates the page for a tab.
    ///   - tabTitle: A closure that resolves the visible title for a tab.
    public init(
        tabs: [Tab],
        selection: Binding<Tab>,
        alignment: HorizontalAlignment = .leading,
        style: ITabPagerStyle = .init(),
        @ViewBuilder content: @escaping (Tab) -> Content,
        tabTitle: @escaping (Tab) -> String
    ) {
        self.tabs = tabs
        self._selection = selection
        self.alignment = alignment
        self.style = style
        self.content = content
        self.tabTitle = tabTitle
    }

    // MARK: Body

    /// The tab strip and UIKit-backed pager, or an empty view when `tabs` is empty.
    public var body: some View {
        if tabs.isEmpty {
            EmptyView()
        } else {
            VStack(spacing: 0) {
                tabStripView
                PagerScrollView(
                    tabs: tabs,
                    selection: $selection,
                    progress: $progress,
                    content: content
                )
            }
            .onAppear {
                // Initialize progress so the indicator starts at the bound selection.
                if let index = tabs.firstIndex(of: selection) {
                    progress = CGFloat(index)
                }
            }
            .onChange(of: selection) { _, newValue in
                // Correct a newly assigned selection that does not exist in the current tabs.
                if !tabs.contains(newValue), let first = tabs.first {
                    selection = first
                }
            }
        }
    }
}

// MARK: - Tab Strip

/// Tab-strip measurement, interaction, edge-fade, and indicator rendering.
extension ITabPager {

    /// The initial scroll anchor derived from the configured horizontal alignment.
    private var initialScrollAnchor: UnitPoint {
        switch alignment {
        case .trailing: return .trailing
        case .center:   return .center
        default:        return .leading
        }
    }

    /// The scrollable title strip, selection centering, fade mask, and indicator overlay.
    private var tabStripView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                HStack(spacing: style.tabSpacing) {
                    ForEach(tabs, id: \.self) { tab in
                        tabButton(tab)
                            .id(tab)
                    }
                }
                .frame(
                    minWidth: containerWidth,
                    alignment: Alignment(horizontal: alignment, vertical: .center)
                )
                .coordinateSpace(name: "tabPagerStrip")
                .onPreferenceChange(TabFrameKey.self) { frames in
                    tabFrames = frames
                    if !isInitialized && !frames.isEmpty {
                        Task { @MainActor in isInitialized = true }
                    }
                }
                .overlay(alignment: .bottom) {
                    indicatorView
                }
                .onAppear {
                    Task { @MainActor in
                        proxy.scrollTo(selection, anchor: selectedTabScrollAnchor())
                    }
                }
                .onChange(of: selection) { _, newValue in
                    Task { @MainActor in
                        withAnimation(.spring(duration: 0.25)) {
                            proxy.scrollTo(newValue, anchor: selectedTabScrollAnchor())
                        }
                    }
                }
            }
        }
        .defaultScrollAnchor(initialScrollAnchor)
        .coordinateSpace(name: "tabPagerScrollViewport")
        .compositingGroup()
        .mask {
            if style.showsTabStripEdgeFade {
                tabStripFadeMask
            } else {
                Rectangle()
                    .fill(.black)
            }
        }
        .onPreferenceChange(TabViewportFrameKey.self) { frames in
            tabViewportFrames = frames
        }
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear { containerWidth = geo.size.width }
                    .onChange(of: geo.size.width) { _, w in containerWidth = w }
            }
        )
    }

    /// The union of all tab frames measured relative to the visible scroll viewport.
    private var tabViewportBounds: CGRect {
        guard let firstFrame = tabViewportFrames.values.first else { return .zero }
        return tabViewportFrames.values.dropFirst().reduce(firstFrame) { bounds, frame in
            bounds.union(frame)
        }
    }

    /// Whether the measured tab content extends beyond the visible container width.
    private var isTabStripOverflowing: Bool {
        containerWidth > 0 && tabViewportBounds.width > containerWidth + 1
    }

    /// Whether content is currently clipped beyond the leading viewport edge.
    private var showsLeadingFade: Bool {
        isTabStripOverflowing && tabViewportBounds.minX < -1
    }

    /// Whether content is currently clipped beyond the trailing viewport edge.
    private var showsTrailingFade: Bool {
        isTabStripOverflowing && tabViewportBounds.maxX > containerWidth + 1
    }

    /// A fixed-width leading and trailing gradient mask for overflowing tab content.
    private var tabStripFadeMask: some View {
        GeometryReader { geo in
            let fadeWidth = min(style.tabStripEdgeFadeWidth, max(0, geo.size.width / 2))
            HStack(spacing: 0) {
                tabStripFadeEdge(isLeading: true, isVisible: showsLeadingFade)
                    .frame(width: fadeWidth)
                Rectangle()
                    .fill(.black)
                tabStripFadeEdge(isLeading: false, isVisible: showsTrailingFade)
                    .frame(width: fadeWidth)
            }
            .transaction { transaction in
                transaction.animation = nil
            }
        }
    }

    @ViewBuilder
    /// Builds one edge of the overflow fade mask.
    ///
    /// - Parameters:
    ///   - isLeading: Whether the gradient belongs to the leading edge.
    ///   - isVisible: Whether clipped content requires the gradient to be visible.
    /// - Returns: A gradient when visible, or an opaque rectangle when hidden.
    private func tabStripFadeEdge(isLeading: Bool, isVisible: Bool) -> some View {
        if isVisible {
            LinearGradient(
                colors: isLeading
                    ? [.clear, .black.opacity(0.7), .black]
                    : [.black, .black.opacity(0.7), .clear],
                startPoint: .leading,
                endPoint: .trailing
            )
        } else {
            Rectangle()
                .fill(.black)
        }
    }

    @ViewBuilder
    /// Builds a tab label whose selected typography and color track fractional page progress.
    ///
    /// - Parameter tab: The tab identity represented by the button.
    /// - Returns: The layered title presentation and its tap gesture.
    private func tabButton(_ tab: Tab) -> some View {
        let index = tabs.firstIndex(of: tab) ?? 0
        // Interpolate selection weight continuously: aligned is 1 and one page away is 0.
        let fraction = max(0.0, 1.0 - abs(progress - CGFloat(index)))
        ZStack {
            // Reserve selected-font width so the label does not resize between states.
            Text(tabTitle(tab))
                .font(style.selectedFont)
                .hidden()
            // Render the unselected layer beneath the selected layer.
            Text(tabTitle(tab))
                .font(style.unselectedFont)
                .foregroundStyle(style.unselectedColor)
            // Fade the selected layer in with fractional progress.
            Text(tabTitle(tab))
                .font(style.selectedFont)
                .foregroundStyle(style.selectedColor)
                .opacity(fraction)
        }
        .padding(.bottom, style.indicatorHeight + style.indicatorSpacing)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(duration: 0.25)) { selection = tab }
        }
        .background(
            GeometryReader { geo in
                Color.clear
                    .preference(
                        key: TabFrameKey.self,
                        value: [AnyHashable(tab): geo.frame(in: .named("tabPagerStrip"))]
                    )
                    .preference(
                        key: TabViewportFrameKey.self,
                        value: [AnyHashable(tab): geo.frame(in: .named("tabPagerScrollViewport"))]
                    )
            }
        )
    }

    /// The capsule indicator interpolated between the neighboring measured tab frames.
    private var indicatorView: some View {
        // Interpolate adjacent frames so the indicator follows the user's finger.
        let lo = max(0, min(Int(progress), tabs.count - 1))
        let hi = min(tabs.count - 1, lo + 1)
        let fraction = progress - CGFloat(lo)

        let fromFrame = tabFrames[AnyHashable(tabs[lo])] ?? .zero
        let toFrame   = tabFrames[AnyHashable(tabs[hi])] ?? fromFrame

        let iw     = lerp(fromFrame.width, toFrame.width, fraction) * style.indicatorWidthRatio
        let midX   = lerp(fromFrame.midX, toFrame.midX, fraction)
        let offsetX = max(0, midX - iw / 2)

        return Capsule()
            .fill(style.indicatorColor)
            .frame(width: max(0, iw), height: style.indicatorHeight)
            .frame(maxWidth: .infinity, alignment: .leading)
            .offset(x: offsetX)
            // Progress is already continuous; animate only the first frame-set transition.
            .animation(isInitialized ? .spring(duration: 0.25) : nil, value: tabFrames.keys.count)
    }
}

#endif
