//
//  AspectVGrid.swift
//  Set Game
//
//  Created by Aleksey on 3/14/23.
//

import SwiftUI

struct AspectVGrid<Item, ItemView>: View where ItemView: View, Item: Identifiable {
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView
    var itemsInGame: Int {
        if items.count >= 12 {
            return items.count
        } else {
            return 12
        }
    }
    
    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                let width: CGFloat = widthThatFits(itemCount: itemsInGame, in: geometry.size, itemAspectRatio: aspectRatio)
                LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0) {
                    ForEach(items) { item in
                        content(item).aspectRatio(aspectRatio, contentMode: .fit).padding(3)
                    }
                }
                Spacer(minLength: 0)
            }
        }
    }
}

private func adaptiveGridItem(width: CGFloat) -> GridItem {
    var gridItem = GridItem(.adaptive(minimum: width))
    gridItem.spacing = 0
    return gridItem
}

private func widthThatFits(itemCount: Int,
                           in size: CGSize,
                           itemAspectRatio: CGFloat) -> CGFloat {
    var columnCount = 1
    var rowCount = itemCount
    
    repeat {
        let itemWidth = size.width / CGFloat(columnCount)
        let itemHeight = itemWidth / itemAspectRatio
        if CGFloat(rowCount) * itemHeight < size.height {
            break
        }
        columnCount += 1
        rowCount = (itemCount + (columnCount - 1)) / columnCount
    } while columnCount < itemCount
    
    if columnCount > itemCount {
        columnCount = itemCount
    }
    return floor(size.width / CGFloat(columnCount))
}
