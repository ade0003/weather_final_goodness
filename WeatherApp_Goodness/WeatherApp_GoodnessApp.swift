//
//  WeatherApp_GoodnessApp.swift
//  WeatherApp_Goodness
//
//  Created by Goodness Ade on 2024-12-12.


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
        
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "font") ?? UIColor.blue]
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "font") ?? UIColor.blue
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(named: "background") ?? UIColor.lightGray]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "background") ?? UIColor.lightGray
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                CityListView(viewModel: cityListViewModel)
                    .tabItem {
                        Label("Cities", systemImage: "list.bullet")
                    }
                    .tag(0)
                SearchView(selectedTab: $selectedTab)  // Pass the binding
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

