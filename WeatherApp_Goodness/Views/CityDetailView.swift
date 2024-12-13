//
//  CityDetailView 2.swift
//  WeatherApp_Goodness
//
//  Created by Goodness Ade on 2024-12-12.
//
import SwiftUI
import MapKit

struct CityDetailView: View {
    @ObservedObject var viewModel: CityDetailViewModel
    let city: City
    @State private var region: MKCoordinateRegion

    init(city: City, viewModel: CityDetailViewModel) {
        self.city = city
        self.viewModel = viewModel
        self._region = State(initialValue: MKCoordinateRegion(
            center: city.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }

    var body: some View {
           ZStack {
               Map(coordinateRegion: $region)
                   .ignoresSafeArea()

               Rectangle()
                   .fill(viewModel.color(for: viewModel.city.temperature))
                   .opacity(0.5) // Adjust this value for desired translucency
                   .ignoresSafeArea()

               LinearGradient(
                   gradient: Gradient(
                       colors: [
                           .clear,
                           .black.opacity(0.2),
                           .black.opacity(0.4)
                       ]
                   ),
                   startPoint: .top,
                   endPoint: .bottom
               )
               .ignoresSafeArea()
            VStack {
                Spacer()
                VStack(spacing: 10) {
                    Text(city.name)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text(city.localTime.formatted(date: .omitted, time: .shortened))
                            .font(.title2)
                            .foregroundColor(.white)
                    
                    Image(systemName: viewModel.city.systemIconName)
                        .font(.system(size: 50))
                        .symbolRenderingMode(.multicolor)
                        .foregroundColor(.yellow)
                    
                    Button(action: {
                        viewModel.toggleTemperatureUnit()
                    }) {
                        Text(viewModel.displayTemperature)
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    
                    Text(viewModel.city.weatherDescription)
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 20) {
                        WeatherDetailItem(title: "Humidity", value: "\(viewModel.city.humidity)%")
                        WeatherDetailItem(title: "Wind", value: "\(Int(viewModel.city.windSpeed)) m/s")
                    }
                }
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(15)

                VStack(alignment: .center) {
                    Text("Hourly Forecast")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(viewModel.hourlyForecast.prefix(12), id: \.time) { forecast in
                                VStack {
                                    Text(forecast.time.formatted(date: .omitted, time: .shortened))
                                        .font(.subheadline)
                                        .foregroundColor(.white)

                                    Image(systemName: getWeatherIcon(for: forecast.iconName))
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                        .font(.system(size: 25))

                                    Text(viewModel.displayHourlyTemperature(forecast.temperature))
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.fetchWeatherDetails()
                await viewModel.fetchHourlyForecast()
            }
        }
    }

    private func getWeatherIcon(for iconCode: String) -> String {
        // Your existing weather icon mapping function
        switch iconCode {
            case "01d": return "sun.max.fill"
            case "01n": return "moon.fill"
            case "02d": return "cloud.sun.fill"
            case "02n": return "cloud.moon.fill"
            case "03d", "03n": return "cloud.fill"
            case "04d", "04n": return "cloud.fill"
            case "09d", "09n": return "cloud.drizzle.fill"
            case "10d": return "cloud.sun.rain.fill"
            case "10n": return "cloud.moon.rain.fill"
            case "11d", "11n": return "cloud.bolt.fill"
            case "13d", "13n": return "snow"
            case "50d", "50n": return "cloud.fog.fill"
            default: return "questionmark"
        }
    }
    
    struct WeatherDetailItem: View {
        let title: String
        let value: String
        
        var body: some View {
            VStack {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
}
