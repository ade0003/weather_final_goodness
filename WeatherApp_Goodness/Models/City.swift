//
//  City.swift
//  WeatherApp_Goodness
//
//  Created by Goodness Ade on 2024-12-12.
//


import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(longitude)
        try container.encode(latitude)
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let longitude = try container.decode(CLLocationDegrees.self)
        let latitude = try container.decode(CLLocationDegrees.self)
        self.init(latitude: latitude, longitude: longitude)
    }
}
import Foundation
import CoreLocation

struct City: Identifiable, Codable {
    let id: UUID
    let name: String
    let coordinate: CLLocationCoordinate2D
    var temperature: Double
    var weatherDescription: String
    var weatherIconName: String
    var uvIndex: Double
    var windSpeed: Double
    var humidity: Int
    var timezone: Int
    
    init(name: String,
         coordinate: CLLocationCoordinate2D,
         temperature: Double = 0,
         weatherDescription: String = "",
         weatherIconName: String = "cloud",
         timezone: Int = 0) {
        self.id = UUID()
        self.name = name
        self.coordinate = coordinate
        self.temperature = temperature
        self.weatherDescription = weatherDescription
        self.weatherIconName = weatherIconName
        self.uvIndex = 0
        self.windSpeed = 0
        self.humidity = 0
        self.timezone = timezone
    }
    
    mutating func updateWeather(with data: WeatherData) {
        self.temperature = data.main.temp
        self.weatherDescription = data.weather.first?.description ?? ""
        self.weatherIconName = data.weather.first?.icon ?? "cloud"
        self.uvIndex = data.uvi ?? 0.0
        self.windSpeed = data.wind.speed
        self.humidity = data.main.humidity
    }
    
    var systemIconName: String {
        switch weatherIconName {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.fill"
        case "02d": return "cloud.sun.fill"
        case "02n": return "cloud.moon.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "cloud.fill"
        case "09d", "09n": return "cloud.rain.fill"
        case "10d": return "cloud.sun.rain.fill"
        case "10n": return "cloud.moon.rain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "snow"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "cloud.fill"
        }
    }
    
    
}
