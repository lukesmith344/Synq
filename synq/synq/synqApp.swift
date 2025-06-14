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
    @State private var onboardingComplete = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if !authService.isAuthenticated {
                    LoginView()
                } else if !onboardingComplete {
                    SplashView()
                        .onDisappear {
                            onboardingComplete = true
                        }
                } else {
                    FeedView()
                }
            }
        }
    }
}

