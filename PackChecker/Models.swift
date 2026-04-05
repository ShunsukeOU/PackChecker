//
//  Models.swift
//  PackChecker
//
//  Created by Shunsuke Taira on 2026/04/03.
//

//Itemset(どこにいく時のアイテムセットか）、PackItem（実際の持ち物）の二つのデータセットを作成する
//
//  Models.swift
//  PackChecker
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class ItemSet {
    var name: String
    var colorName: String
    
    @Relationship(deleteRule: .cascade) var items: [PackItem]
    
    init(name: String, colorName: String = "indigo", items: [PackItem] = []) {
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

extension String {
    var toColor: Color {
        switch self {
        case "red": return .pink
        case "orange": return .orange
        case "yellow": return .yellow
        case "green": return .mint
        case "blue": return .cyan
        case "indigo": return .indigo
        case "purple": return .purple
        case "gray": return Color(UIColor.systemGray)
        default: return .indigo
        }
    }
}
