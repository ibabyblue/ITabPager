//
//  ContentView.swift
//  ITabPagerDemo
//
//  Created by ibabyblue on 2026/05/08.
//  Copyright © 2026 ibabyblue. All rights reserved.
//

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
            .navigationTitle("ITabPager")
        }
    }
}
