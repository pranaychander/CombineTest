//
//  Story.swift
//  Comb-E
//
//  Created by pranay chander on 03/07/21.
//

import Foundation


struct Story: Codable {
    let id: Int
    let title: String
    let url: String

    static func placeholder() -> Story {
        return Story(id: 0, title: "", url: "")
    }
}
