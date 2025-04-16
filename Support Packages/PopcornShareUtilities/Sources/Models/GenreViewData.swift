//
//  GenreViewData.swift
//  PopcornShareUtilities
//
//  Created by Paulo Lazarini on 28/01/25.
//

import Foundation

public struct GenreViewData: Hashable, Identifiable, Equatable, Sendable {
    public let id: Int
    let name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
