//
//  SearchError.swift
//  WeatherApp_Goodness
//
//  Created by Goodness Ade on 2024-12-12.
//


import Foundation

struct SearchError: Error, Identifiable {
    let id = UUID()
    let error: Error
    
    init(_ error: Error) {
        self.error = error
    }
    
    var localizedDescription: String {
        error.localizedDescription
    }
}
