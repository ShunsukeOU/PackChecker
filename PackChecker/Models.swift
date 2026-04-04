//
//  Models.swift
//  PackChecker
//
//  Created by Shunsuke Taira on 2026/04/03.
//

//Itemset(どこにいく時のアイテムセットか）、PackItem（実際の持ち物）の二つのデータセットを作成する
import Foundation
import SwiftData
import SwiftUI //色を扱うために追加

@Model
final class ItemSet {
    var name: String
    var colorName: String//カードの色を保存する
    
    @Relationship(deleteRule: .cascade) var items: [PackItem]
    
    init(name: String, colorName: String = "blue", items: [PackItem] = []) {
        self.name = name
        self.colorName = colorName
        self.items = items
    }
}

@Model
final class PackItem {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

//保存した色の名前実際のSwiftUIのColorに変換するための便利な拡張機能を追加
extension String {
    var toColor: Color {
        switch self {
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "green": return .green
        case "blue": return .blue
        case "purple": return .purple
        case "pink": return .pink
        case "gray": return .gray
        default: return .blue
        }
    }
}
