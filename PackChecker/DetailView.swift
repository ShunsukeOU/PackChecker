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
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditSheet = false
    
    var body: some View {
        List {
            ForEach(itemSet.items) { item in
                Text(item.name)
            }
        }
        .navigationTitle(itemSet.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                //純正メモアプリ風のメニュー
                Menu {
                    Button {
                        showingEditSheet = true
                    } label: {
                        Label("編集", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        deleteSet()
                    } label: {
                        Label("削除", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            AddEditSetView(itemSetToEdit: itemSet)
        }
    }
    
    private func deleteSet() {
        context.delete(itemSet)
        try? context.save()
        dismiss()
    }
}
