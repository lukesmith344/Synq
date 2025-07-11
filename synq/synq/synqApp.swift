//
//  synqApp.swift
//  synq
//
//  Created by Luke Smith on 5/30/25.
//

import SwiftUI
import Firebase
import FirebaseMessaging
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        requestNotificationAuthorization()
        return true
    }
    
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    // Handle notification tap
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let title = response.notification.request.content.title
        if title == "Synq time 🎵" {
            NotificationCenter.default.post(name: .openDropSongView, object: nil)
        }
        completionHandler()
    }
    
    // For foreground notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    // FCM token refresh
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // Optionally send token to your server
    }
}

extension Notification.Name {
    static let openDropSongView = Notification.Name("openDropSongView")
}

@main
struct synqApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var authService = AuthenticationService()
    @StateObject private var onboardingViewModel = OnboardingViewModel(authService: AuthenticationService())
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if !authService.isAuthenticated {
                    LoginView(authService: authService)
                } else if let profile = authService.user, !profile.onboardingComplete {
                    OnboardingContainerView(viewModel: onboardingViewModel)
                } else {
                    MainView(authService: authService)
                }
            }
        }
    }
}

