//
//  LoginViewModel.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isShowingPassword: Bool = false
}
