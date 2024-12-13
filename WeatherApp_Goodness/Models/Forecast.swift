//
//  Forecast.swift
//  WeatherApp_Goodness
//
//  Created by Goodness Ade on 2024-12-12.
//


import Foundation

struct Forecast: Identifiable {
    let id = UUID()
    let time: Date
    let temperature: Double
    let iconName: String
}
