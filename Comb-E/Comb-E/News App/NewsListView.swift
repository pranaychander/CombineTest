//
//  NewsListView.swift
//  Comb-E
//
//  Created by pranay chander on 03/07/21.
//

import SwiftUI
import Combine

struct NewsListView: View {

    @ObservedObject private var storyListVM = StoryListViewModel()

    var body: some View {
        NavigationView {
            List(self.storyListVM.stories, id: \.id) { story in
                NavigationLink(destination: {
                    StoryDetailView(storyID: story.id )
                }) {
                    Text("\(story.title)")
                }
            }
            .navigationTitle("Hacker News")
        }
    }
}

struct NewsListView_Previews: PreviewProvider {
    static var previews: some View {
        NewsListView()
    }
}
