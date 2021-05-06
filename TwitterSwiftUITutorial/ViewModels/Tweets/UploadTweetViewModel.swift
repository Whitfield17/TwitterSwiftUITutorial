//
//  UploadTweetViewModel.swift
//  TwitterSwiftUITutorial
//
//  Created by Braydon Whitfield on 2021-05-03.
//

import SwiftUI
import Firebase

class UploadTweetViewModel: ObservableObject {
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    func uploadTweet(caption: String) {
        guard let user = AuthViewModel.shared.user else { return }
//        Gives us a reference to the document id
        let docRef = COLLECTION_TWEETS.document()
        
        let data: [String: Any] = ["uid": user.id,
                                   "caption": caption,
                                   "fullname": user.fullname,
                                   "timestamp": Timestamp(date: Date()),
                                   "username": user.username,
                                   "profileImageUrl": user.profileImageUrl,
                                   "likes": 0,
                                   "id": docRef.documentID]
        
        docRef.setData(data) { (_) in
            print("DEBUG: Successfully uploaded tweet")
            self.isPresented = false
        }
    }
}

