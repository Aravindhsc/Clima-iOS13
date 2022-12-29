//
//  WeatherManager.swift
//  Clima
//
//  Created by Aravindh Sambanda Chandrasekaran on 7.10.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol weatherDelegateManager {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=****&units=metric"
    
    // Assigning delegate
    var delegate: weatherDelegateManager?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    // "with" is used to make the code more readable
    func performRequest(with urlString: String) {
        // 1. create a URL
        if let url = URL(string: urlString) {
            
            //2. create a URL Session
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            // Closure
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    // Inside closure always start delegate with self keyword
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    // self keyword always used to call a method inside closure
                    if let weather = self.performJsonParser(safeData) {
                        self.delegate?.didUpdateWeather(self,weather: weather)
                    }
                }
                    
            }
            //4. start the task
            task.resume()
        }
    }
    
    func performJsonParser(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let temp = decodedData.main.temp
            let name = decodedData.name
            let id = decodedData.weather[0].id
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            print(name)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}


    
    
