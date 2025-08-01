//
//  ColorGenerator_AssignmentApp.swift
//  ColorGenerator-Assignment
//
//  Created by Hari's Mac on 01.08.2025.
//

import SwiftUI
import SwiftData
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct ColorGenerator_AssignmentApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [ColorCode.self])
    }
}
