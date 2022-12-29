//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchFieldText: UITextField!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        
        // Set delegate before requesting the location, otherwise app crashes
        locationManager.delegate = self
        locationManager.requestLocation()
        // delegate reports view controller when user enters/edits something in the text field
        // self refers to the current ciew controller.
        
        weatherManager.delegate = self
        searchFieldText.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        print(searchFieldText.text!)
        searchFieldText.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchFieldText.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            searchFieldText.placeholder = "Type something..."
            return false
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}

//MARK: - weatherDelegateManager

extension WeatherViewController: weatherDelegateManager {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchFieldText.text {
            weatherManager.fetchWeather(cityName: city)
        }
            
        searchFieldText.text = ""
        searchFieldText.placeholder = "Search"
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        // Protect app from crashing when fetching data from the request
        DispatchQueue.main.sync {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text=weather.cityName
        }
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print("Current Latitude is \(lat) and Longitude is \(lon)")
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
