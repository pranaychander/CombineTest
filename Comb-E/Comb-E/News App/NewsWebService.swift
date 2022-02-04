//
//  NewsWebService.swift
//  Comb-E
//
//  Created by pranay chander on 03/07/21.
//

import Foundation
import Combine

class NewsWebService {
    func getAllTopStories() -> AnyPublisher<[Story], Error> {
        guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty") else {
            fatalError()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type:[Int].self , decoder: JSONDecoder())
            .flatMap({ storyIds in
                return self.mergeStories(ids: storyIds)
            })
            .scan([], { stories, story -> [Story] in
                return stories + [story]
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func mergeStories(ids storyIDs: [Int]) -> AnyPublisher<Story, Error> {
        let storyIds = Array(storyIDs.prefix(50))

        let initialPub = getStoryByID(id: storyIds[0])
        let remainder = Array(storyIds.dropFirst())

        return remainder.reduce(initialPub) { combin, id in
            return combin.merge(with: getStoryByID(id: id))
                .eraseToAnyPublisher()
        }

    }

    func getStoryByID(id: Int) -> AnyPublisher<Story, Error> {
        guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(id).json?print=pretty") else {
            fatalError()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Story.self , decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
