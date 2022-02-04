//
//  StoryDetailView.swift
//  Comb-E
//
//  Created by pranay chander on 03/07/21.
//

import SwiftUI

struct StoryDetailView: View {

    @ObservedObject var storyDetailVM: StoryDetailViewModel
    var storyId: Int

    init(storyID: Int) {
        self.storyId = storyID
        self.storyDetailVM = StoryDetailViewModel()
    }

    var body: some View {
        VStack {
            Text(storyDetailVM.title)
            WebView(url: storyDetailVM.url)
        }.onAppear {
            storyDetailVM.fetchStoryDetails(storyId1: self.storyId)
        }
    }
}

struct StoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StoryDetailView(storyID: 8878)
    }
}



