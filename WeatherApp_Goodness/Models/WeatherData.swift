//
//  WeatherData.swift
//  WeatherApp_Goodness
//
//  Created by Goodness Ade on 2024-12-12.
//
import Foundation

struct WeatherData: Codable {
    let main: MainWeather
    let weather: [WeatherCondition]
    let wind: WindData
    let uvi: Double? 

    enum CodingKeys: String, CodingKey {
        case main, weather, wind
        case uvi
    }
}


struct MainWeather: Codable {
    let temp: Double
    let humidity: Int
}

struct WeatherCondition: Codable {
    let description: String
    let icon: String
}

struct WindData: Codable {
    let speed: Double
}
