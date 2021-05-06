//
//  AuthViewModel.swift
//  TwitterSwiftUITutorial
//
//  Created by Braydon Whitfield on 2021-02-09.
//

import SwiftUI
import Firebase

class AuthViewModel: ObservableObject {
//    Keeps track of whether or not the user is logged in
    @Published var userSession: FirebaseAuth.User?
//    Keeps track of whether or not the process of logging in or signing up is ongoing
    @Published var isAuthenticating = false
//    If we get an error when the user logs in we are going to set this error then show an alert message to the user
    @Published var error: Error?
//    Keeps track of the user, will be set to load user data
    @Published var user: User?
//    Shared instance of AuthViewModel is used to access the user wherever we want in the application without having
//    to reinstantiate the AuthViewModel
    static let shared = AuthViewModel()
    
    init() {
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func login(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Failed to login: \(error.localizedDescription)")
                return
            }
            
            self.userSession = result?.user
            self.fetchUser()
        }
    }
    
    func registerUser(email: String, password: String, username: String, fullname: String, profileImage: UIImage) {
        
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child(filename)
        
//            Uploads the image to the storage reference
        storageRef.putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
                print("DEBUG: Failed to upload image: \(error.localizedDescription)")
                return
            }
            
//                Gives us back a download url for the image
            storageRef.downloadURL { (url, _) in
                guard let profileImageURL = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print("DEBUG: Error \(error.localizedDescription)")
                        return
                    }
                    
//                    Getting the user from the result of createUser
                    guard let user = result?.user else { return }
                    
                    let data = ["email": email,
                                "username": username.lowercased(),
                                "fullname": fullname,
                                "profileImageUrl": profileImageURL,
                                "uid": user.uid]
                    
                    Firestore.firestore().collection("users").document(user.uid).setData(data) { (_) in
                        self.userSession = user
                        self.fetchUser()
                    }
                }
            }
        }
    }
    
    func signOut() {
        userSession = nil
        user = nil
        try? Auth.auth().signOut()
    }
    
    func fetchUser() {
        guard let uid = userSession?.uid else { return }
        
//        Going into the users collection in Firestore, and finds the uid document for the current user
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, _) in
//            Getting the data returned back from Firestore
            guard let data = snapshot?.data() else { return }
            self.user = User(dictionary: data)
            
            print("Signed in as \(self.user?.fullname ?? "Nope")")
        }
    }
    
    func tabTitle(forIndex index: Int) -> String {
        switch index {
        case 0: return "Home"
        case 1: return "Search"
        case 2: return "Messages"
        default: return ""
        }
    }
}
