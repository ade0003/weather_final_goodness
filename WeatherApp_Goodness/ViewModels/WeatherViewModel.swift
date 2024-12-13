//
//  WeatherViewModel.swift
//  WeatherApp_Goodness
//
//  Created by Goodness Ade on 2024-12-12.
//
import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var cities: [WeatherData] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let weatherService = WeatherService()
    
    func addCity(named cityName: String) async {
        guard !cityName.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            let weatherData = try await weatherService.fetchWeather(for: cityName)
            cities.append(weatherData)
        } catch {
            errorMessage = "Error fetching weather: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func removeCity(at index: Int) {
        cities.remove(at: index)
    }
}
