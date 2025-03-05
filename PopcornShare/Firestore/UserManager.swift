//
//  UserManager.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 26/05/24.
//

import Foundation
import PopcornShareProfile
import PopcornShareUtilities
import PopcornShareAuthentication

import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserManager: UserManagerType {
    
    static let shared = UserManager()
    
    private init() {}
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        let userData: [String:Any] = [
            "user_id" : auth.uid,
            "photo_url" : auth.photoUrl ?? "",
            "date_created" : Timestamp(),
            "email" : auth.email ?? "",
            "username" : auth.username ?? "",
            "favorite_ids" : [],
        ]
        
        try await Firestore.firestore()
            .collection("users")
            .document(auth.uid)
            .setData(userData)
    }
    
    func updateUser(_ user: DBUser) async throws {
        let userData: [String:Any] = [
            "user_id" : user.userId,
            "photo_url" : user.photoUrl ?? "",
            "date_updated" : Timestamp(),
            "email" : user.email ?? "",
            "username" : user.username ?? "",
            "city" : user.username ?? "",
            "country" : user.username ?? "",
            "biography" : user.biography ?? "",
            "favorite_ids" : [],
        ]
        
        try await Firestore.firestore()
            .collection("users")
            .document(user.userId)
            .updateData(userData)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data(),
              let userId = data["user_id"] as? String else { throw URLError(.badServerResponse) }
        
        let email = data["email"] as? String
        let username = data["username"] as? String
        let photoUrl = data["photo_url"] as? String
        let city = data["photo_url"] as? String
        let country = data["photo_url"] as? String
        let biography = data["biography"] as? String
        let dateCreated = data["date_created"] as? Date
        let dateUpdated = data["date_updated"] as? Date
        let favoriteIds = data["favorite_ids"] as? [String]
        
        return DBUser(
            userId: userId,
            dateCreated: dateCreated,
            dateUpdated: dateUpdated,
            photoUrl: photoUrl,
            email: email,
            username: username,
            city: city,
            country: country,
            biography: biography,
            favoriteIds: favoriteIds
        )
    }
}
