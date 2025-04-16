//
//  MovieCategory.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 07/03/25.
//

import Foundation

enum MovieCategory: CaseIterable {
    case popular, topRated, nowPlaying, upcoming
    
    var title: String {
        switch self {
        case .popular:
            "Popular Movies"
        case .topRated:
            "Top Rated"
        case .nowPlaying:
            "Now Playing"
        case .upcoming:
            "Upcoming"
        }
    }
}
