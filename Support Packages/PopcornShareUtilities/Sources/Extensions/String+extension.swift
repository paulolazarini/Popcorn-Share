//
//  String+extension.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import Foundation

public extension String {
    static var empty: String { "" }
    
    static func makePosterPath(_ path: String) -> String {
        "https://image.tmdb.org/t/p/original" + path
    }
}
