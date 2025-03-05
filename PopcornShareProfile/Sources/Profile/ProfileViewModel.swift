//
//  ProfileViewModel.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import SwiftUI
import Combine

import PopcornShareUtilities

final class ProfileViewModel: ObservableObject, @unchecked Sendable {
    enum Events {
        case onSignOutTapped
    }
    
//    @Published private(set) var user: DBUser? = nil
    @Published private(set) var user: DBUser? = DBUser(
        userId: "15",
        dateCreated: Date(),
        photoUrl: .empty,
        email: "test@hotmail.com",
        username: "Test da Silva",
        city: "Joinville",
        country: "Brazil",
        biography: "I'm a positive person. I love to travel and eat. Always available to watch a movie.",
        favoriteIds: []
    )
    
    let events = PassthroughSubject<Events, Never>()
    
    let userManager: UserManagerType
    let userUuid: String
    
    init(
        userManager: UserManagerType,
        userUuid: String
    ) {
        self.userManager = userManager
        self.userUuid = userUuid
        
//        Task { await loadCurrentUser() }
    }
    
    @MainActor func loadCurrentUser() async {
        do {
            self.user = try await userManager.getUser(userId: userUuid)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        events.send(.onSignOutTapped)
    }
}
