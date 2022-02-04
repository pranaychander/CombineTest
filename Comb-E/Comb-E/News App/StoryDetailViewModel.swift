//
//  StoryDetailViewModel.swift
//  Comb-E
//
//  Created by pranay chander on 03/07/21.
//

import Foundation
import Combine

class StoryDetailViewModel: ObservableObject {
    private var cancellable: Cancellable?
    @Published private var story: Story?

    func fetchStoryDetails(storyId1: Int) {
        cancellable = NewsWebService().getStoryByID(id: storyId1)
            .catch { _ in Just(Story.placeholder() )}
            .sink(receiveCompletion: { _ in }, receiveValue: { story1 in
                self.story = story1
            })
    }
}

extension StoryDetailViewModel {
    var title: String {
        self.story?.title ?? ""
    }

    var url: String {
        self.story?.url ?? ""
    }
}
