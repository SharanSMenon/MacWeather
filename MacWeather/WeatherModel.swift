//
//  WeatherModel.swift
//  WeatherModel
//
//  Created by Sharan Sajiv Menon on 8/5/21.
//

import Foundation
import SwiftUI
import NationalWeatherService

private let defaultIcon = "❓"
private let iconMap = [
    "Drizzle" : "🌧",
    "Thunderstorm" : "⛈",
    "Rain": "🌧",
    "Snow": "❄️",
    "Sunny": "☀️",
    "Mostly Cloudy" : "☁️",
    "Mostly Clear" : "🌤",
    "Mostly Sunny" : "🌤",
]

class WeatherViewModel: ObservableObject {
    @Published var cityName: String = "City Name"
    @Published var temperature: Measurement<UnitTemperature> =  Measurement(value:0, unit: UnitTemperature.celsius)
    @Published var weatherDescription: String = "--"
    @Published var weatherIcon: String = defaultIcon
    @Published var shouldShowLocationError: Bool = false
    @Published var windSpeed: String = "--"
    @Published var isDaytime: Bool = false
    
    public let weatherService: WeatherService
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    func refresh() {
        weatherService.loadWeatherData {weather, placemark, error in
            guard let weather = weather else { return }
            guard let placemark = placemark else { return }
            let period = weather.periods[0]
//            print(weather.periods[0])
            self.cityName = placemark.locality ?? "No City"
            self.temperature = period.temperature
            self.weatherDescription = period.shortForecast
            self.windSpeed = period.windSpeed.description
            self.isDaytime = period.isDaytime
            self.weatherIcon = iconMap[period.shortForecast] ?? defaultIcon
        }
    }
}
