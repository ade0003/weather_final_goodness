//
//  WeatherApp_GoodnessApp.swift
//  WeatherApp_Goodness
//
//  Created by Goodness Ade on 2024-12-12.


import SwiftUI

import SwiftUI

@main
struct WeatherApp: App {
    @StateObject private var settingsStore = SettingsStore()
    @StateObject private var cityListViewModel = CityListViewModel()
    @State private var selectedTab = 0
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "tabBackground")
        
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "selected") ?? UIColor.blue]
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "selected") ?? UIColor.blue
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(named: "unselected") ?? UIColor.lightGray]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "unselected") ?? UIColor.lightGray
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        settingsStore.onRefreshNeeded = { [weak cityListViewModel] in
            await cityListViewModel?.refreshWeather()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                CityListView(viewModel: cityListViewModel)
                    .tabItem {
                        Label("Cities", systemImage: "list.bullet")
                    }
                    .tag(0)
                SearchView(selectedTab: $selectedTab)
                    .environmentObject(cityListViewModel)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(1)
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(2)
            }
            .environmentObject(settingsStore)
        }
    }
}
