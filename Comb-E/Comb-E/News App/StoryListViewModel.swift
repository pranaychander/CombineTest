//
//  StoryListViewModel.swift
//  Comb-E
//
//  Created by pranay chander on 03/07/21.
//

import Foundation
import Combine

class StoryListViewModel: ObservableObject {

    @Published var stories : [StoryViewModel] = []
    private var cancellable: AnyCancellable?

    init() {
        fetchTopStories()
    }

    func fetchTopStories() {
        cancellable = NewsWebService()
            .getAllTopStories()
            .map { $0.map { StoryViewModel(story: $0) } }
            .sink { _ in } receiveValue: { self.stories = $0 }
    }
}

struct StoryViewModel {
    let story: Story
    var id: Int { story.id }
    var title: String { story.title }
    var url: String { story.url }
}
