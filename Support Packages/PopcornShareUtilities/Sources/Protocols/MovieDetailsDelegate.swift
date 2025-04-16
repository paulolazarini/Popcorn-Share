//
//  MovieDetailsDelegate.swift
//  PopcornShareUtilities
//
//  Created by Paulo Lazarini on 06/03/25.
//

import Foundation

@MainActor
public protocol MovieDetailsDelegate: AnyObject {
    func presentMovieDetails(for movie: MovieViewData)
}
