//
//  SettingsStore.swift
//  WeatherApp_Goodness
//
//  Created by Goodness Ade on 2024-12-12.
//


import SwiftUI
import Combine

class SettingsStore: ObservableObject {
    @Published private(set) var refreshInterval: Int
    @Published private(set) var isCelsius: Bool
    private var refreshTimer: Timer?
    var onRefreshNeeded: (() async -> Void)?

    init() {
        let savedInterval = UserDefaults.standard.integer(forKey: "refreshInterval")
        self.refreshInterval = savedInterval != 0 ? savedInterval : 300
        self.isCelsius = UserDefaults.standard.bool(forKey: "isCelsius")
    }
    
    func setRefreshInterval(_ interval: Int) {
        self.refreshInterval = interval
        UserDefaults.standard.set(interval, forKey: "refreshInterval")
        scheduleNextRefresh()
    }
    
    func setTemperatureUnit(celsius: Bool) {
        self.isCelsius = celsius
        UserDefaults.standard.set(celsius, forKey: "isCelsius")
    }

    private func scheduleNextRefresh() {
        refreshTimer?.invalidate()
        refreshTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(refreshInterval), repeats: true) { [weak self] _ in
            Task {
                await self?.onRefreshNeeded?()
            }
        }
    }
    
    func stopRefresh() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
}
