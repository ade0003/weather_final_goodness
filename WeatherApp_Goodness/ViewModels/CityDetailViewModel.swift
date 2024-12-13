//
//  CityDetailViewModel.swift
//  WeatherApp_Goodness
//
//  Created by Goodness Ade on 2024-12-12.
//

import SwiftUI
import CoreLocation
import SwiftUI

class CityDetailViewModel: ObservableObject {
    @Published var city: City
    @Published var hourlyForecast: [Forecast] = []
    @Published var errorMessage: String?
    @Published var isCelsius = true
    
    private let weatherService = WeatherService()
    
    init(city: City) {
        self.city = city
        Task {
            await fetchWeatherDetails()
            await fetchHourlyForecast()
        }
    }
    
    func fetchWeatherDetails() async {
        do {
            let weatherData = try await weatherService.fetchWeather(for: city.name)
            DispatchQueue.main.async {
                self.city.updateWeather(with: weatherData)
                self.errorMessage = nil
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error fetching weather details: \(error.localizedDescription)"
            }
            print("Error fetching weather details for \(city.name): \(error)")
        }
    }

    func fetchHourlyForecast() async {
        do {
            hourlyForecast = try await weatherService.fetchHourlyForecast(for: city.name)
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error fetching hourly forecast: \(error.localizedDescription)"
            }
            print("Error fetching hourly forecast for \(city.name): \(error)")
        }
    }
    
    func toggleTemperatureUnit() {
            isCelsius.toggle()
        }
    
    var displayTemperature: String {
           let temp = isCelsius ? city.temperature : (city.temperature * 9/5 + 32)
           return "\(Int(temp))°\(isCelsius ? "C" : "F")"
       }
}
