//
//  FeedView.swift
//  TwitterSwiftUITutorial
//
//  Created by Braydon Whitfield on 2021-01-26.
//

import SwiftUI

struct FeedView: View {
    //State variable that determines whether or not we are presenting that view
    @State var isShowingNewTweetView = false
    @ObservedObject var viewModel = FeedViewModel()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                //LazyVStack only loads cells on an as needed basis
                LazyVStack {
                    ForEach(viewModel.tweets) { tweet in
                        NavigationLink(
                            destination: TweetDetailView(tweet: tweet),
                            label: {
                                TweetCell(tweet: tweet)
                            })
                    }
                }
                .padding()
                
            }
            
            //Making the floating button
            //When button is clicked isShowingNewTweetView gets toggled to true
            Button(action: { isShowingNewTweetView.toggle() },
                   label: {
                    Image("tweet")
                        .resizable()
                        //Properly renders the tint colour of an image
                        .renderingMode(.template)
                        .frame(width: 32, height: 32)
                        .padding()
                   })
            .background(Color(.systemBlue))
            .foregroundColor(.white)
            .clipShape(Circle())
            .padding()
            //Gets toggled to true based on the state variable
            .fullScreenCover(isPresented: $isShowingNewTweetView) {
                //Creates the new tweet view and passes isShowingNewTweetView to that view
                NewTweetView(isPresented: $isShowingNewTweetView)
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
