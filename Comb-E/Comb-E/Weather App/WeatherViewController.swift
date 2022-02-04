//
//  WeatherViewController.swift
//  Comb-E
//
//  Created by pranay chander on 29/06/21.
//

import UIKit
import Combine

class WeatherViewController: UIViewController {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputTempLabel: UILabel!

    var cancellables = [AnyCancellable]()
    let webService = WebService()
    override func viewDidLoad() {
        super.viewDidLoad()

        let pub = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self.inputTextField)
            .compactMap { ($0.object as! UITextField).text?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)}
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .flatMap { city in
                return self.webService
                    .fetchWeather(city: city)
                    .catch { _ in Empty()}
                    .map { $0 }
            }
            .print()
            .sink { self.outputTempLabel.text = "\($0.temp) *F"}
            .store(in: &cancellables)




//        webService
//            .fetchWeather(city: "Houston")
//            .catch { _ in Just(Weather.placeholder)}
//            .map { weather in
//                if let temp = weather.temp {
//                    return "\(temp) *C"
//                } else {
//                    return "Error GETTING WEATHER"
//                }
//            }
//            .assign(to: \.text, on: outputTempLabel)
//            .store(in: &cancellables)
        
    }

    @IBAction func cityEntered(_ sender: UITextField) {
        
    }
}
