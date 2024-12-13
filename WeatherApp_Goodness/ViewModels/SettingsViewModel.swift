//
//  SettingsViewModel.swift
//  WeatherApp_Goodness
//
//  Created by Goodness Ade on 2024-12-12.
//


import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var refreshInterval: Int = 300 
    @Published var temperatureUnit: TemperatureUnit = .celsius
    
    enum TemperatureUnit: String, CaseIterable {
        case celsius = "°C"
        case fahrenheit = "°F"
    }
    
    func convertTemperature(_ celsius: Double) -> Double {
        switch temperatureUnit {
        case .celsius:
            return celsius
        case .fahrenheit:
            return (celsius * 9/5) + 32
        }
    }
}
