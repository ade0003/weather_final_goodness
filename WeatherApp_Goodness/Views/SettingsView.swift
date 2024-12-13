//
//  SettingsView.swift
//  WeatherApp_Goodness
//
//  Created by Goodness Ade on 2024-12-12.
//


import SwiftUI
struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                Form {
                    Section {
                        VStack {
                            Picker("Refresh Interval", selection: $viewModel.refreshInterval) {
                                Text("5 minutes").tag(300)
                                Text("15 minutes").tag(900)
                                Text("30 minutes").tag(1800)
                                Text("1 hour").tag(3600)
                            }
                            
                            Picker("Temperature Unit", selection: $viewModel.temperatureUnit) {
                                ForEach(SettingsViewModel.TemperatureUnit.allCases, id: \.self) { unit in
                                    Text(unit.rawValue).tag(unit)
                                }
                            }
                        }
                        .padding()
                        .background(Material.ultraThinMaterial.opacity(0.5))
                        .cornerRadius(10)
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    
                    Section {
                        NavigationLink(destination: AboutView()) {
                            Text("About")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Material.ultraThinMaterial.opacity(0.5))
                        .cornerRadius(10)
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
        }
    }
}
