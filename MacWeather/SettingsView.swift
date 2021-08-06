//
//  SettingsView.swift
//  SettingsView
//
//  Created by Sharan Sajiv Menon on 8/6/21.
//

import SwiftUI

enum TemperatureUnit: String, CaseIterable, Identifiable {
    case fahrenheit = "Fahrenheit"
    case celsius = "Celsius"
    case kelvin = "Kelvin"
    
    var id: String { self.rawValue }
}

struct SettingsView: View {
    @AppStorage("selectedUnit") private var selectedUnit: TemperatureUnit = TemperatureUnit.celsius
//    @State private var selectedUnit = TemperatureUnit.celsius
    
    var body: some View {
        Form {
            Picker("Unit:", selection: $selectedUnit) {
                Text("Celsius").tag(TemperatureUnit.celsius)
                Text("Fahrenheit").tag(TemperatureUnit.fahrenheit)
                Text("Kelvin").tag(TemperatureUnit.kelvin)
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width:300)
        }
        .frame(width:400, height:200)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
