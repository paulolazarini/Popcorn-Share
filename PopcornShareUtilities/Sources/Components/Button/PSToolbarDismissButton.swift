//
//  PSToolbarDismissButton.swift
//  PopcornShareUtilities
//
//  Created by Paulo Lazarini on 25/02/25.
//

import SwiftUI

public struct PSToolbarDismissButton: ToolbarContent {
    let dismiss: () -> Void
    
    public init(dismiss: @escaping () -> Void) {
        self.dismiss = dismiss
    }

    public var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundStyle(.black)
                    .padding(.small)
            }
        }
    }
}
