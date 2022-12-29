//
//  WeatherData.swift
//  Clima
//
//  Created by Aravindh Sambanda Chandrasekaran on 10.10.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

// Codable is a protocol
struct Weather: Codable {
    let id: Int
}
