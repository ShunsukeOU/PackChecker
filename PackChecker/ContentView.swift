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
                            .background(itemSet.colorName.toColor)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button {
                                itemSetToEdit = itemSet
                            } label: {
                                Label("編集", systemImage: "pencil")
                            }
                            
                            Button(role: .destructive) {
                                context.delete(itemSet)
                                try? context.save()//一応確実に削除する
                            } label: {
                                Label("削除", systemImage: "trash")
                            }
                        } preview: {
                            DetailView(itemSet: itemSet)
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
}
