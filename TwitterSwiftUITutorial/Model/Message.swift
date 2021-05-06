//
//  Message.swift
//  TwitterSwiftUITutorial
//
//  Created by Braydon Whitfield on 2021-01-31.
//

import Firebase

struct Message: Identifiable {
    let text: String
    let user: User
    let toId: String
    let fromId: String
    let isFromCurrentUser: Bool
    let timestamp: Timestamp
    let id: String
    
    var chatPartnerId: String { return isFromCurrentUser ? toId : fromId }
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.id = dictionary["id"] as? String ?? ""
    }
}

struct MockMessage: Identifiable {
    let id: Int
    let imageName: String
    let messageText: String
    let isCurrentUser: Bool
}

let MOCK_MESSAGES: [MockMessage] = [
    .init(id: 0, imageName: "spiderman", messageText: "Hey what's up?", isCurrentUser: false),
    .init(id: 1, imageName: "batman", messageText: "Not much you?", isCurrentUser: true),
    .init(id: 2, imageName: "batman", messageText: "How's the Marvel Universe?", isCurrentUser: true),
    .init(id: 3, imageName: "spiderman", messageText: "Pretty good man", isCurrentUser: false),
    .init(id: 4, imageName: "spiderman", messageText: "How's it going with The Joker?", isCurrentUser: false),
    .init(id: 5, imageName: "batman", messageText: "Not good", isCurrentUser: true),
]
