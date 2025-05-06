protocol MoviesManagerType: ObservableObject {
    var favoritedMovies: [MovieViewData] { get set }
    
    func toggleFavorite(userId: String, movieId: String) async
    func fetchFavoritedMovie(using id: String) async throws
    func getFavoriteIds(userId: String) async throws
}