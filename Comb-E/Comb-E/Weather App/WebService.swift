//
//  WebService.swift
//  Comb-E
//
//  Created by pranay chander on 29/06/21.
//

import Foundation
import Combine

class WebService {
    func fetchWeather(city: String) -> AnyPublisher<Weather, Error> {
        guard let url = URL(string: Constants.URLs.weather(city: city)) else { fatalError() }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .map { $0.main}
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
