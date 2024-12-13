//
//  SearchViewModel.swift
//  WeatherApp_Goodness
//
//  Created by Goodness Ade on 2024-12-12.
//

import Foundation
import CoreLocation

class SearchViewModel: ObservableObject {
    @Published var allCities: [City] = []
    @Published var filteredCities: [City] = []
    @Published var searchText: String = ""
    private let cityService = CityService()
    private let geocoder = CLGeocoder()

    init() {
        Task {
            await loadCities()
        }
    }
    
    func geocodeCity(_ cityName: String) async throws -> CLLocationCoordinate2D {
            return try await withCheckedThrowingContinuation { continuation in
                geocoder.geocodeAddressString(cityName) { placemarks, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    if let location = placemarks?.first?.location?.coordinate {
                        continuation.resume(returning: location)
                    } else {
                        continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Location not found"]))
                    }
                }
            }
        }

    func loadCities() async {
        do {
            allCities = try await cityService.fetchAllCities()
            filteredCities = allCities
        } catch {
            print("Error loading cities: \(error)")
        }
    }

    func filterCities() {
        if searchText.isEmpty {
            filteredCities = allCities
        } else {
            filteredCities = allCities.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}
