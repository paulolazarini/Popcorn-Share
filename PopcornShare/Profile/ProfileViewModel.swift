//
//  ProfileViewModel.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import Foundation
import PopcornShareAuthentication
import Combine

final class ProfileViewModel: ObservableObject {
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
    
    let authManager: AuthenticationManagerType
    let userManager: UserManagerType
    
    init(
        authManager: AuthenticationManagerType = AuthenticationManager.shared,
        userManager: UserManagerType = UserManager.shared
    ) {
        self.authManager = authManager
        self.userManager = userManager
    }
    
    @MainActor func loadCurrentUser() async {
        do {
            let authDataResult = try authManager.getAuthenticatedUser()
            self.user = try await userManager.getUser(userId: authDataResult.uid)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try authManager.signOut()
            events.send(.onSignOutTapped)
        } catch { print(error.localizedDescription) }
    }
}
