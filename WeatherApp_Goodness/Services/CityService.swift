//
//  CityService.swift
//  WeatherApp_Goodness
//
//  Created by Goodness Ade on 2024-12-13.
//
import Foundation
import CoreLocation

struct CountryResponse: Codable {
    let error: Bool
    let msg: String
    let data: [Country]
}

struct Country: Codable {
    let country: String
    let cities: [String]
}

class CityService {
    let baseURL = "https://countriesnow.space/api/v0.1/countries"

    func fetchAllCities() async throws -> [City] {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let countryResponse = try JSONDecoder().decode(CountryResponse.self, from: data)

        return countryResponse.data.flatMap { country in
            country.cities.map { cityName in
                City(name: cityName, coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
            }
        }
    }
}
