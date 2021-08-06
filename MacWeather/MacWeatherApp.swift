//
//  MacWeatherApp.swift
//  MacWeather
//
//  Created by Sharan Sajiv Menon on 8/6/21.
//

import SwiftUI

@main
struct MacWeatherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: WeatherViewModel(weatherService: WeatherService()))
            .frame(width:400, height:400)
        }
        
        Settings {
            SettingsView()
        }
    }
}
