//
//  TwitterSwiftUITutorialApp.swift
//  TwitterSwiftUITutorial
//
//  Created by Braydon Whitfield on 2021-01-25.
//

import SwiftUI
import Firebase

@main
struct TwitterSwiftUITutorialApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
//            AuthViewModel.shared fires off the static instance of AuthViewModel
            ContentView().environmentObject(AuthViewModel.shared)
        }
    }
}
