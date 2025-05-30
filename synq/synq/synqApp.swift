//
//  synqApp.swift
//  synq
//
//  Created by Luke Smith on 5/30/25.
//

import SwiftUI

@main
struct synqApp: App {
    @StateObject private var authService = AuthenticationService()
    
    var body: some Scene {
        WindowGroup {
            if authService.isAuthenticated {
                MainView(authService: authService)
            } else {
                LoginView()
            }
        }
    }
}
