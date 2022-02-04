//
//  Constants.swift
//  Comb-E
//
//  Created by pranay chander on 29/06/21.
//

import Foundation

struct Constants {

    struct URLs {
        static func weather(city: String) -> String {
            return "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(Constants.APIKEY)"
        }
    }

    static let APIKEY = "af6ba8fc15c360b5b90f400eedb4e9be"
}
