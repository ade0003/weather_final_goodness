//
//  CityListViewModel.swift
//  WeatherApp_Goodness
//
//  Created by Goodness Ade on 2024-12-12.
//


import SwiftUI
import CoreLocation



class CityListViewModel: ObservableObject {
    
    @Published var cities: [City] = []
    private let weatherService = WeatherService()
    private var timer: Timer?
    
    init() {
        
        cities = [
            City(name: "New York", coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)),
            City(name: "London", coordinate: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278))
        ]
        
        startTimer()
    }
    
    func startTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
                self?.objectWillChange.send()
            }
        }
        
        deinit {
            timer?.invalidate()
        }
        
    func refreshWeather() async {
        await withTaskGroup(of: Void.self) { group in
            for index in cities.indices {
                group.addTask {
                    do {
                        let weatherData = try await self.weatherService.fetchWeather(for: self.cities[index].name)
                        await MainActor.run {
                            self.cities[index].updateWeather(with: weatherData)
                        }
                    } catch {
                        print("Error refreshing weather for \(self.cities[index].name): \(error)")
                    }
                }
            }
        }
    }

    
    func removeCity(at offsets: IndexSet) {
        cities.remove(atOffsets: offsets)
    }
    
    func addCity(_ city: City) {
        cities.append(city)
    }
}
