//
//  SettingsStore.swift
//  WeatherApp_Goodness
//
//  Created by Goodness Ade on 2024-12-12.
//


import SwiftUI
import Combine

class SettingsStore: ObservableObject {
    @Published var refreshInterval: Int = 300 
    @Published var isCelsius: Bool = true
    
    func convertTemperature(_ temp: Double) -> Double {
        return isCelsius ? temp : (temp * 9/5) + 32
    }
}
