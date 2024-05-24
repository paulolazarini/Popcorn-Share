//
//  Movies.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import Foundation

public struct Movies: Codable, Sendable {
    public let results: [MovieDetails]
    public let page: Int?
    
    public init(
        results: [MovieDetails],
        page: Int?
    ) {
        self.results = results
        self.page = page
    }
}
