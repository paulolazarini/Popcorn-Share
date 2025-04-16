//
//  PopcornShareIcon.swift
//  PopcornShareUtilities
//
//  Created by Paulo Lazarini on 22/01/25.
//


import SwiftUI

public struct PSIcon: View {
    let size: CGSize
    
    public init(
        size: CGSize = CGSize(width: 75, height: 75)
    ) {
        self.size = size
    }
    
    public var body: some View {
        Image("icon")
            .resizable()
            .scaledToFit()
            .frame(size: size)
    }
}
