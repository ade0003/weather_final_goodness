//
//  CityDetailViewModel.swift
//  WeatherApp_Goodness
//
//  Created by Goodness Ade on 2024-12-12.
//

import SwiftUI
import CoreLocation
import SwiftUI
import CoreLocation

class CityDetailViewModel: ObservableObject {
    @Published var city: City
    @Published var hourlyForecast: [Forecast] = []
    @Published var errorMessage: String?
    @Published var isCelsius = true
    private var timer: Timer?
    
    private let weatherService = WeatherService()
    private let animationDuration: Double = 0.3
    
    init(city: City) {
        self.city = city
        startTimer()
        Task {
            await fetchWeatherDetails()
            await fetchHourlyForecast()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func toggleTemperatureUnit() {
        withAnimation(.easeInOut(duration: animationDuration)) {
            isCelsius.toggle()
        }
    }
    
    var displayTemperature: String {
        let temp = isCelsius ? city.temperature : (city.temperature * 9/5 + 32)
        return "\(Int(temp))°\(isCelsius ? "C" : "F")"
    }
    
    func displayHourlyTemperature(_ temp: Double) -> String {
        let convertedTemp = isCelsius ? temp : (temp * 9/5 + 32)
        return "\(Int(convertedTemp))°\(isCelsius ? "C" : "F")"
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
    
    func color(for temperature: Double) -> Color {
        let normalized = min(max((temperature + 30) / 70, 0), 1)
        return Color(
            hue: (1.0 - normalized) * 0.67,
            saturation: 0.8,
            brightness: 0.9
        )
    }
}
