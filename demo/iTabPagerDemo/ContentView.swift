import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Basic (3 tabs)") {
                    BasicDemo()
                }
                NavigationLink("Overflow (8 tabs)") {
                    OverflowTabDemo()
                }
                NavigationLink("Custom Style") {
                    CustomStyleDemo()
                }
            }
            .navigationTitle("iTabPager")
        }
    }
}
