//
//  SearchView.swift
//  WeatherApp_Goodness
//
//  Created by Goodness Ade on 2024-12-12.
//


import SwiftUI
struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @EnvironmentObject var cityListViewModel: CityListViewModel
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack {
                    SearchBarView(searchText: $viewModel.searchText)
                        .onChange(of: viewModel.searchText) { _ in
                            viewModel.filterCities()
                        }
                    List(viewModel.filteredCities) { city in
                        HStack {
                            Text(city.name)
                                .font(.headline)
                            Spacer()
                            Button {
                                Task {
                                    if let coordinate = try? await viewModel.geocodeCity(city.name) {
                                        let cityWithCoordinates = City(
                                            name: city.name,
                                            coordinate: coordinate,
                                            temperature: 0,
                                            weatherDescription: "",
                                            weatherIconName: "cloud"
                                        )
                                        cityListViewModel.addCity(cityWithCoordinates)
                                        selectedTab = 0
                                    }
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(Color("tabBackground"))
                                    .font(.title2)
                            }
                        }
                        .padding()
                        .background(Material.ultraThinMaterial.opacity(0.5))
                        .cornerRadius(10)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Search Cities")
        }
    }
}
struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color("tabBackground"))
            TextField("Search for a city...", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)  
        }
        .padding()
    }
}
