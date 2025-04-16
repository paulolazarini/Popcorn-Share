//
//  View+extension.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import SwiftUI

public extension View {
    func isLoading(_ isLoading: Bool) -> some View {
        self
            .overlay {
                if isLoading {
                    ZStack {
                        Color.white.opacity(0.5).ignoresSafeArea()
                        
                        ProgressView()
                    }
                }
            }
    }
    
    @ViewBuilder
    func isHidden(_ isHidden: Binding<Bool>) -> some View {
        if isHidden.wrappedValue {
            self
                .hidden()
        } else {
            self
        }
    }
    
    @ViewBuilder
    func renderIf(_ condition: Bool) -> some View {
        if condition {
            self
        }
    }
    
    func hAlignment(_ alignment: Alignment) -> some View {
        HStack {
            self
        }
        .frame(
            maxWidth: .infinity,
            alignment: alignment
        )
    }
    
    func vAlignment(_ alignment: Alignment) -> some View {
        VStack {
            self
        }
        .frame(
            maxHeight: .infinity,
            alignment: alignment
        )
    }
    
    var horizontalDivider: some View {
        HStack {
            VerticalDivider()
            self
            VerticalDivider()
        }
    }
    
    func frame(size: CGSize) -> some View {
        self.frame(
            width: size.width,
            height: size.height,
            alignment: .center
        )
    }
}
