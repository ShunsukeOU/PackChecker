//
//  AddEditSetView.swift
//  PackChecker
//
//  Created by Shunsuke Taira on 2026/04/04.
//

import SwiftUI
import SwiftData

struct AddEditSetView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var selectedColor: String = "red"
    @State private var newItemName: String = ""
    @State private var items: [String] = []
    
    var itemSetToEdit: ItemSet?
    
    let colors = ["red", "orange", "yellow", "green", "blue", "gray"]
    
    init(itemSetToEdit: ItemSet? = nil) {
        self.itemSetToEdit = itemSetToEdit
        if let set = itemSetToEdit {
            _name = State(initialValue: set.name)
            _selectedColor = State(initialValue: set.colorName)
            _items = State(initialValue: set.items.map { $0.name })
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("行き先")) {
                    TextField("例: ジム、サウナ", text: $name)
                }
                
                Section(header: Text("持ち物リスト")) {
                    HStack {
                        TextField("新しい持ち物を入力", text: $newItemName)
                            .onSubmit { addItem() }
                        
                        Button(action: addItem) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(selectedColor.toColor)
                        }
                    }
                    
                    ForEach(items, id: \.self) { item in
                        Text(item)
                    }
                    .onDelete { indexSet in
                        items.remove(atOffsets: indexSet)
                    }
                }
                
                Section(header: Text("カテゴリ")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(colors, id: \.self) { colorName in
                                Circle()
                                    .fill(colorName.toColor)
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary, lineWidth: selectedColor == colorName ? 3 : 0)
                                    )
                                    .onTapGesture {
                                        let impactHeavy = UIImpactFeedbackGenerator(style: .light)
                                        impactHeavy.impactOccurred()
                                        selectedColor = colorName
                                    }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle(itemSetToEdit == nil ? "新規追加" : "セットの編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        save()
                    }
                    .disabled(name.isEmpty || items.isEmpty)
                }
            }
        }
    }
    
    private func addItem() {
        let trimmed = newItemName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        if !items.contains(trimmed) {
            items.append(trimmed)
        }
        newItemName = ""
    }
    
    private func save() {//データを保存する関数
        if let set = itemSetToEdit {
            set.name = name
            set.colorName = selectedColor
            
            for item in set.items { context.delete(item) }
            set.items.removeAll()
            for itemName in items {
                set.items.append(PackItem(name: itemName))
            }
        } else {
            let newSet = ItemSet(name: name, colorName: selectedColor)
            for itemName in items {
                newSet.items.append(PackItem(name: itemName))
            }
            context.insert(newSet)
        }
        
        do {//一応
            try context.save()
        } catch {
            print("エラー：保存に失敗しました: \(error)")
        }
        
        dismiss()
    }
}
