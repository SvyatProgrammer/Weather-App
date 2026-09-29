//
//  ContentView.swift
//  Weather App
//
//  Created by Свят on 28.09.26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var weather : WeatherResponse?
    @State private var isLoading = false
    @State private var errorMessage : String?
    @State private var city = "Brest"
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.blue.opacity(0.15),.white], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    searchBar
                    
                    content
                }
            }
            .refreshable {
                await loadWeather(for: city)
            }
            .navigationTitle("Weather")
        }
        .task {
            await loadWeather(for: city)
        }
    }
    
    private var searchBar : some View {
        HStack {
            TextField("Enter city", text: $searchText)
                .textFieldStyle(.roundedBorder)
            
            Button {
                searchCity()
            } label: {
                Image(systemName: "magnifyingglass")
            }
            .buttonStyle(.glassProminent)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var content : some View {
        if isLoading {
            ProgressView("Loading...")
        } else if let errorMessage {
            VStack(spacing: 15) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                
                Text("Something went wrong")
                    .font(.headline)
                
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Button("Try again") {
                    Task {
                        await loadWeather(for: city)
                    }
                }
                .buttonStyle(.glassProminent)
            }
            .padding()
        } else if let weather {
            WeatherContent(weather: weather, city: city)
        }
    }
    
    private func loadWeather(for cityName : String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let weatherService = WeatherServices()
            
            let location = try await weatherService
                .searchCity(name: cityName)
            
            let result = try await weatherService
                .fetchWeather(latitude: location.latitude, longitude: location.longitude)
            
            weather = result
            city = cityName
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func searchCity() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else {
            return
        }
        
        Task {
            await loadWeather(for: query)
        }
    }
}

#Preview {
    ContentView()
}
