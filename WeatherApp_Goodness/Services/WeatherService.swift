//
//  WeatherService.swift
//  WeatherApp_Goodness
//
//  Created by Goodness Ade on 2024-12-12.
//

import Foundation
import CoreLocation
import Foundation
import CoreLocation
import Foundation
import CoreLocation
import Foundation

class WeatherService {
    private let apiKey =  APi.weatherAPIKey
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    
    func fetchWeather(for city: String) async throws -> WeatherData {
        let urlString = "\(baseURL)/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
        return weatherData
    }

    func fetchHourlyForecast(for city: String) async throws -> [Forecast] {
        let urlString = "\(baseURL)/forecast?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let forecastData = try JSONDecoder().decode(ForecastResponse.self, from: data)
        
        return forecastData.list.map { item in
            Forecast(
                time: Date(timeIntervalSince1970: TimeInterval(item.dt)),
                temperature: item.main.temp,
                iconName: item.weather.first?.icon ?? "cloud"
            )
        }
    }
}

struct ForecastResponse: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable {
    let dt: Int
    let main: MainWeather
    let weather: [WeatherCondition]
}
