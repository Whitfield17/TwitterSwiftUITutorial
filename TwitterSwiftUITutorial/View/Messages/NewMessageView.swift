//
//  NewMessageView.swift
//  TwitterSwiftUITutorial
//
//  Created by Braydon Whitfield on 2021-01-31.
//

import SwiftUI

struct NewMessageView: View {
    @State var searchText = ""
    @Binding var startChat: Bool
    @Binding var show: Bool
    @Binding var user: User?
    @ObservedObject var viewModel = SearchViewModel(config: .newMessage)
    
    var body: some View {
        ScrollView {
            SearchBar(text: $searchText)
                .padding()
            
            VStack(alignment: .leading) {
                ForEach(searchText.isEmpty ? viewModel.users : viewModel.filteredUsers(searchText)) { user in
                    HStack { Spacer() }
                    Button(action: {
                        self.show.toggle()
                        self.startChat.toggle()
                        self.user = user
                    }, label: {
                        UserCell(user: user)
                    })
                }
            }.padding(.leading)
        }
    }}

