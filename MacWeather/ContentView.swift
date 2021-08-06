//
//  ContentView.swift
//  MacWeather
//
//  Created by Sharan Sajiv Menon on 8/6/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @AppStorage("selectedUnit") private var selectedUnit: TemperatureUnit = TemperatureUnit.celsius
    
    var body: some View {
        ZStack {
            if viewModel.isDaytime {
                Color.blue.ignoresSafeArea()
            } else {
                Color.black
                    .ignoresSafeArea()
            }
            VStack {
                Text(viewModel.weatherIcon)
                    .font(.system(size:120))
                Text(viewModel.cityName)
                    .font(.largeTitle)
                switch selectedUnit {
                case .fahrenheit:
                    Text("\(String(format:"%.0f", viewModel.temperature.converted(to: UnitTemperature.fahrenheit).value)) ºF")
                        .font(.system(size:50))
                        .bold()
                case .celsius:
                    Text("\(String(format:"%.0f", viewModel.temperature.converted(to: UnitTemperature.celsius).value)) ºC")
                        .font(.system(size:50))
                        .bold()
                case .kelvin:
                    Text("\(String(format:"%.0f", viewModel.temperature.converted(to: UnitTemperature.kelvin).value)) ºK")
                        .font(.system(size:50))
                        .bold()
                }
                Text(viewModel.weatherDescription)
            }
            .onAppear(perform: viewModel.refresh)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel(weatherService: WeatherService()))
    }
}
