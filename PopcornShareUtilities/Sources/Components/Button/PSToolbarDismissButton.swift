//
//  PSToolbarDismissButton.swift
//  PopcornShareUtilities
//
//  Created by Paulo Lazarini on 25/02/25.
//

import SwiftUI

public struct PSToolbarDismissButton: ToolbarContent {
    @Environment(\.dismiss) private var dismiss
    
    public init() {}

    public var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundStyle(.black)
                    .padding(.small)
                    .background {
                        Circle()
                            .fill(Color.Background.yellow)
                            .opacity(0.3)
                    }
            }
        }
    }
}
