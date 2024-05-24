//
//  PSGridView.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 28/01/25.
//

import SwiftUI

struct PSGridView<Data: Hashable, Content: View>: View {
    @Binding var data: [Data]
    let gridItems: [GridItem]
    let orientation: Orientation
    @ViewBuilder let content: (Int, Data) -> Content
    
    public init(
        gridItems: [GridItem],
        orientation: Orientation = .vertical,
        data: Binding<[Data]>,
        @ViewBuilder content: @escaping (Int, Data) -> Content
    ) {
        self._data = data
        self.gridItems = gridItems
        self.orientation = orientation
        self.content = content
    }
    
    var body: some View {
        gridView
            .animation(.default, value: data)
    }
    
    @ViewBuilder
    var gridView: some View {
        switch orientation {
        case .vertical:
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: gridItems, spacing: .small) { gridContent }
            }
        case .horizontal:
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: gridItems, spacing: .small) { gridContent }
            }
        }
    }

    var gridContent: some View {
        ForEach(Array(data.enumerated()), id: \.element) { index, item in
            content(index, item)
        }
    }
}

extension PSGridView {
    enum Orientation {
        case horizontal, vertical
    }
}
