//
//  Weather.swift
//  Comb-E
//
//  Created by pranay chander on 29/06/21.
//

import Foundation

struct WeatherResponse: Codable {
    let main: Weather
}

struct Weather: Codable {
    let temp: Double
    let humidity: Double

    static var placeholder: Weather? {
        return nil
    }
}
