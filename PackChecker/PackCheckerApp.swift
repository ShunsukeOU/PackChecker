//
//  PackCheckerApp.swift
//  PackChecker
//
//  Created by Shunsuke Taira on 2026/04/03.
//

import SwiftUI
import SwiftData

@main
struct PackCheckerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [ItemSet.self, PackItem.self])
    }
}
