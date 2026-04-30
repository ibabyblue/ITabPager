#if canImport(UIKit)
import SwiftUI

struct TabFrameKey: PreferenceKey {
    static var defaultValue: [AnyHashable: CGRect] = [:]
    static func reduce(
        value: inout [AnyHashable: CGRect],
        nextValue: () -> [AnyHashable: CGRect]
    ) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
#endif
