//
//  ContentView.swift
//  PackChecker
//
//  Created by Shunsuke Taira on 2026/04/03.
//


import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var itemSets: [ItemSet]
    
    @State private var showingAddSheet = false
    @State private var itemSetToEdit: ItemSet?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(itemSets) { itemSet in
                        NavigationLink(destination: DetailView(itemSet: itemSet)) {
                            HStack {
                                Text(itemSet.name)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding()
                            .frame(height: 80)
                            .background(itemSet.colorName.toColor.gradient)
                            .cornerRadius(16)
                            .shadow(color: itemSet.colorName.toColor.opacity(0.4), radius: 6, x: 0, y: 4)
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button {
                                itemSetToEdit = itemSet
                            } label: {
                                Label("編集", systemImage: "pencil")
                            }
                            
                            Button(role: .destructive) {
                                deleteSet(itemSet)
                            } label: {
                                Label("削除", systemImage: "trash")
                            }
                        } preview: {
                            //クイックルックのサイズを中身の縦横に合わせる
                            ItemSetPreviewView(itemSet: itemSet)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Where are you going?")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus")
                            .fontWeight(.bold)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddEditSetView()
            }
            .sheet(item: $itemSetToEdit) { itemSet in
                AddEditSetView(itemSetToEdit: itemSet)
            }
        }
    }
    
    private func deleteSet(_ itemSet: ItemSet) {
        context.delete(itemSet)
        try? context.save()
    }
}

//追加の挙動（アイテムカードを長押ししした時のクイックルック）
struct ItemSetPreviewView: View {
    var itemSet: ItemSet
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(itemSet.name)
                .font(.headline)
                .foregroundColor(itemSet.colorName.toColor)
            
            VStack(alignment: .leading, spacing: 8) {
                if itemSet.items.isEmpty {
                    Text("持ち物がありません")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else {
                    ForEach(itemSet.items) { item in
                        HStack {
                            Image(systemName: "circle")
                                .font(.system(size: 20))
                                .foregroundColor(.secondary)
                            Text(item.name)
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
        .padding(20)
    }
}
