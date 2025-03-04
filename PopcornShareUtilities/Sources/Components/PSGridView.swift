//
//  PSGridView.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 28/01/25.
//

import SwiftUI

public struct PSGridView<Data: Hashable, Content: View>: View {
    @Binding var data: [Data]
    let gridItems: [GridItem]
    let orientation: Orientation
    let didLoadLastCell: (() -> Void)?
    @ViewBuilder let content: (Int, Data) -> Content
    
    public init(
        gridItems: [GridItem],
        orientation: Orientation = .vertical,
        didLoadLastCell: (() -> Void)? = nil,
        data: Binding<[Data]>,
        @ViewBuilder content: @escaping (Int, Data) -> Content
    ) {
        self._data = data
        self.gridItems = gridItems
        self.orientation = orientation
        self.didLoadLastCell = didLoadLastCell
        self.content = content
    }
    
    public var body: some View {
        gridView
            .animation(.default, value: data)
    }
}

private extension PSGridView {
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
                .onAppear {
                    if let didLoadLastCell, data[index] == data.last {
                        didLoadLastCell()
                    }
                }
        }
    }
}

public extension PSGridView {
    enum Orientation {
        case horizontal, vertical
    }
}
