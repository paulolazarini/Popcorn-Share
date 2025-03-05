//
//  ProfileView.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import SwiftUI
import PopcornShareUtilities

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State var isPresentingProfileOptionsPopover = false
    
    var location: String? {
        guard let city = viewModel.user?.city,
              let country = viewModel.user?.country else { return nil }
        
        return "\(city), \(country)"
    }
    
    var username: String {
        viewModel.user?.username ?? "Undefined"
    }
    
    var body: some View {
        VStack(spacing: .small) {
            profileImage
            
            ScrollView {
                VStack(spacing: .medium) {
                    usernameView
                    
                    locationView
                    
                    biographyView
                    
                    PSButton("Follow") {
                        
                    }
                    .padding(.top, .medium)
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .background(buildBackground)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                profileOptionsButton
                    .popover(isPresented: $isPresentingProfileOptionsPopover) {
                        profileOptionPopover
                    }
            }
        }
    }
    
    var profileOptionsButton: some View {
        Button {
            isPresentingProfileOptionsPopover.toggle()
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(.white)
        }
    }
    
    var profileOptionPopover: some View {
        VStack(spacing: .small) {
            Button("Edit profile") { }
            Divider()
            Button("Log out") {
                isPresentingProfileOptionsPopover = false
                viewModel.signOut()
            }
            .foregroundStyle(.red)
        }
        .padding(.medium)
        .presentationCompactAdaptation(.popover)
    }
    
    var usernameView: some View {
        Text(username)
            .font(.title)
            .bold()
    }
    
    @ViewBuilder
    var biographyView: some View {
        if let bio = viewModel.user?.biography {
            Text(bio)
                .padding(.horizontal, .large)
                .multilineTextAlignment(.center)
        }
    }
    
    @ViewBuilder
    var locationView: some View {
        if let location {
            Text(location)
                .foregroundStyle(.gray)
                .font(.title3)
                .bold()
        }
    }
    
    var buildBackground: some View {
        ZStack(alignment: .top) {
            Image("icon", bundle: .main)
                .resizable()
                .frame(height: 300)
                .blur(radius: .small)
            
            RoundedRectangle(cornerRadius: .large)
                .foregroundStyle(.white)
                .offset(y: 150)
        }
        .ignoresSafeArea()
    }
    
    var profileImage: some View {
        Image("icon", bundle: .main)
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
            .clipShape(.circle)
            .shadow(radius: .medium)
    }
}

//#Preview {
//    ProfileView(viewModel: ProfileViewModel(user: .init(userId: "")))
//}
