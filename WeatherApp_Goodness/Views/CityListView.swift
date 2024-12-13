//
//  CityListView.swift
//  WeatherApp_Goodness
//
//  Created by Goodness Ade on 2024-12-12.
//

import SwiftUI

import SwiftUI

struct CityListView: View {
    @ObservedObject var viewModel: CityListViewModel
    @State private var selectedCity: City?

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .ignoresSafeArea()
                List {
                    ForEach(viewModel.cities) { city in
                        NavigationLink(destination: CityDetailView(city: city, viewModel: CityDetailViewModel(city: city))) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(city.name)
                                        .font(.headline)
                                    Text(city.localTime.formatted(date: .omitted, time: .shortened))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(city.weatherDescription)
                                        .font(.subheadline)
                                }
                                Spacer()
                                Image(systemName: city.systemIconName)
                                    .symbolRenderingMode(.multicolor)
                                Text("\(Int(city.temperature))°")
                                    .font(.title2)
                            }
                            .padding()
                            .background(Material.ultraThinMaterial.opacity(0.5))
                            .cornerRadius(10)
                        }
                        .tint(Color("tabBackground"))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: viewModel.removeCity)
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                .navigationTitle("Cities")
                .toolbar {
                    EditButton()
                }
                .onAppear {
                    Task {
                        await viewModel.refreshWeather()
                    }
                }
            }
        }
    }
}
