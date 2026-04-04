//
//  DetailView.swift
//  PackChecker
//
//  Created by Shunsuke Taira on 2026/04/03.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    var itemSet: ItemSet
    
    var body: some View {
        List {
            ForEach(itemSet.items) { item in
                Text(item.name)
            }
        }
        .navigationTitle(itemSet.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
