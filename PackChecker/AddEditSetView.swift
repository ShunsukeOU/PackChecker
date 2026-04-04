import SwiftUI
import SwiftData

struct AddEditSetView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    // 入力用の状態変数
    @State private var name: String = ""
    @State private var selectedColor: String = "blue"
    @State private var newItemName: String = ""
    @State private var items: [String] = []
    
    var itemSetToEdit: ItemSet? // 編集モードの場合、ここにデータが渡される
    
    let colors = ["red", "orange", "yellow", "green", "blue", "purple", "pink", "gray"]
    
    // 画面が開かれた時の初期設定（編集時は既存データをセットする）
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
                // ① 行き先の名前
                Section(header: Text("行き先")) {
                    TextField("例: ジム用、サウナ用", text: $name)
                }
                
                // ② カラー選択（丸いボタンを横スクロール）
                Section(header: Text("カードのカラー")) {
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
                                        // 軽く振動させる（HapticFeedback）
                                        let impactHeavy = UIImpactFeedbackGenerator(style: .light)
                                        impactHeavy.impactOccurred()
                                        selectedColor = colorName
                                    }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                // ③ 持ち物の追加
                Section(header: Text("持ち物リスト")) {
                    HStack {
                        TextField("新しい持ち物を入力", text: $newItemName)
                            .onSubmit { addItem() } // キーボードの確定でも追加
                        
                        Button(action: addItem) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(selectedColor.toColor)
                        }
                    }
                    
                    // 追加された持ち物リスト（スワイプで削除可能）
                    ForEach(items, id: \.self) { item in
                        Text(item)
                    }
                    .onDelete { indexSet in
                        items.remove(atOffsets: indexSet)
                    }
                }
            }
            .navigationTitle(itemSetToEdit == nil ? "新しいセット" : "セットの編集")
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
                    // 名前か持ち物が空なら保存ボタンを押せないようにする
                    .disabled(name.isEmpty || items.isEmpty)
                }
            }
        }
    }
    
    // 持ち物を配列に追加する処理
    private func addItem() {
        let trimmed = newItemName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        if !items.contains(trimmed) {
            items.append(trimmed)
        }
        newItemName = ""
    }
    
    // データを保存する処理
    private func save() {
        if let set = itemSetToEdit {
            // ▼ 既存データの更新（編集）
            set.name = name
            set.colorName = selectedColor
            
            // 一度古い持ち物を消して、新しく入れ直す
            for item in set.items { context.delete(item) }
            set.items.removeAll()
            for itemName in items {
                set.items.append(PackItem(name: itemName))
            }
        } else {
            // ▼ 新規作成
            let newSet = ItemSet(name: name, colorName: selectedColor)
            for itemName in items {
                newSet.items.append(PackItem(name: itemName))
            }
            context.insert(newSet)
        }
        dismiss()
    }
}