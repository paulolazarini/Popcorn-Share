//
//  URL+extension.swift
//  PopcornShareUtilities
//
//  Created by Paulo Lazarini on 28/01/25.
//

import Foundation

public extension URL {
    static func makePosterPath(_ posterPath: String) -> Self? {
        URL(string: "https://image.tmdb.org/t/p/original" + posterPath)
    }
}
