# iTabPager 设计文档

**日期：** 2026-04-30  
**平台：** iOS 17+  
**形态：** Swift Package（纯库，无 App 内部依赖）

---

## 目标

封装一套完整的 Tab + Pager 联动控件，对调用者暴露唯一的 `TabPager` 视图。调用者只需提供 tab 数组和每个 tab 对应的内容 View，tab bar 与内容容器的联动、手势、指示器动画全部内部处理。

---

## 架构

```
TabPager (public SwiftUI View)
├── private var tabStripView: some View    ← tab bar 渲染（私有扩展）
│     ↕ Binding<Tab>  +  progress: CGFloat
└── PagerScrollView (internal UIViewRepresentable)
      └── UIScrollView (isPagingEnabled = true)
            └── UIHostingController<Content> × N（滑动窗口懒加载）
```

### 状态归属

`progress: CGFloat` 是 `TabPager` 内部的 `@State`，是两个子组件之间的唯一共享状态：
- `PagerScrollView`：通过 Coordinator 回调写入
- `tabStripView`：只读，用于驱动指示器位置

```
TabPager @State progress: CGFloat
         ↗ 写入（scrollViewDidScroll）   ↘ 读取（指示器插值）
PagerScrollView                          tabStripView
```

### 数据流

| 用户行为 | 触发路径 |
|---|---|
| 点击 Tab | `selection` 变化 → `PagerScrollView` 程序化 scroll |
| 手指拖动 Pager | `scrollViewDidScroll` → `progress` 实时更新 → tabStripView 指示器跟随 |
| 手指松开 Pager | `scrollViewDidEndDecelerating` → `selection` 更新到最近页 |

### 手势冲突

`UIScrollView.isPagingEnabled = true` 配合 UIKit 内置的正交手势消歧：初始方向横向才触发翻页，竖向直接交给 `UIHostingController` 内部的 `ScrollView` / `List`。无需额外手势代码。

---

## 公开 API

### TabPager

```swift
public struct TabPager<Tab: Hashable, Content: View>: View {
    public init(
        tabs: [Tab],
        selection: Binding<Tab>,
        alignment: HorizontalAlignment = .leading,
        style: TabPagerStyle = .init(),
        @ViewBuilder content: @escaping (Tab) -> Content,
        tabTitle: @escaping (Tab) -> String
    )
}
```

**最简用法：**

```swift
TabPager(tabs: ChatsTab.allCases, selection: $tab) { tab in
    MyListView(tab: tab)
} tabTitle: { tab in
    tab.title
}
```

### TabPagerStyle

```swift
public struct TabPagerStyle {
    // Tab bar 文字
    var selectedFont: Font        = .system(size: 17, weight: .bold)
    var unselectedFont: Font      = .system(size: 17, weight: .regular)
    var selectedColor: Color      = .primary
    var unselectedColor: Color    = .secondary

    // 指示器
    var indicatorColor: Color     = .primary
    var indicatorWidthRatio: CGFloat = 0.5
    var indicatorHeight: CGFloat  = 3
    var indicatorSpacing: CGFloat = 0

    // Tab 布局
    var tabSpacing: CGFloat       = 20
}
```

所有默认值不依赖 App 内部资源（无 `R.Color` 引用），确保库可独立发布。

---

## 实时指示器跟随

### progress 定义

`progress` 是一个连续浮点数，范围 `0.0 ... CGFloat(tabs.count - 1)`，表示当前滚动位置：

```
pages:    [  0  ] [  1  ] [  2  ] [  3  ]
progress:  0.0     1.0     2.0     3.0
拖动到 page1 和 page2 之间 30% 处 → progress = 1.3
```

### 计算链

```swift
// PagerScrollView Coordinator
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let progress = scrollView.contentOffset.x / scrollView.bounds.width
    onProgressChange(progress)
}

// tabStripView 内指示器插值
let lo       = Int(progress)
let hi       = min(lo + 1, tabs.count - 1)
let fraction = progress - CGFloat(lo)

let fromFrame = tabFrames[tabs[lo]]
let toFrame   = tabFrames[tabs[hi]]

let midX  = lerp(fromFrame.midX, toFrame.midX, fraction)
let width = lerp(fromFrame.width, toFrame.width, fraction) * style.indicatorWidthRatio
indicatorOffsetX = midX - width / 2
```

### tab bar 同步滚动

当 `progress` 越过整数 ± 0.5 临界点时，将对应 tab 滚动居中（复用 `MSegmentedTab` 的 `ScrollViewReader.scrollTo` 逻辑）。

---

## 懒加载

只保活当前页 ± 1 页的 `UIHostingController`（滑动窗口）：

- 进入窗口：`addChild` → `addSubview` → `didMove(toParent:)`
- 离开窗口：`willMove(toParent: nil)` → `removeFromSuperview` → `removeFromParent`
- 占位 `UIView` 始终存在于 `UIScrollView`，保证总 `contentSize` 正确

### `@Environment` 透传

`UIHostingController` 不自动继承 SwiftUI Environment，在 `updateUIView` 中显式注入：

```swift
vc.rootView = content(tabs[index])
    .environment(\.colorScheme, colorScheme)
    .environment(\.dynamicTypeSize, dynamicTypeSize)
    .environment(\.locale, locale)
```

---

## 边界情况

| 场景 | 处理 |
|---|---|
| `tabs` 为空 | 返回 `EmptyView()` |
| `selection` 不在 `tabs` 里 | 修正为 `tabs[0]`，不崩溃 |
| 设备旋转 / 宽度变化 | `updateUIView` 重算所有页面 frame，`setContentOffset` 跳到当前页 |
| 快速连续点击不同 tab | `setContentOffset(_:animated:true)` 串行，UIKit 自动取消中间帧 |
| 只有 1 个 tab | `scrollView.isScrollEnabled = false`，指示器静止 |

---

## 文件结构

```
Sources/iTabPager/
├── TabPager.swift          ← 公开入口 View
├── TabPagerStyle.swift     ← 公开样式配置
├── PagerScrollView.swift   ← UIViewRepresentable，UIScrollView 封装
└── Internal/
    ├── TabFrameKey.swift   ← PreferenceKey，收集 tab frame
    └── Lerp.swift          ← lerp 工具函数

Tests/iTabPagerTests/
└── iTabPagerTests.swift    ← progress 插值、selection 修正的单元测试
```

---

## 非目标

- 不支持 iOS 16 及以下
- 不提供竖向翻页
- 不内置下拉刷新
- 不支持动态增删 tab（初版）
