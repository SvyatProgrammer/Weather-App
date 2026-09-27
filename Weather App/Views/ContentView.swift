//
//  ContentView.swift
//  Weather App
//
//  Created by Свят on 28.09.26.
//

import SwiftUI

struct ContentView: View {
    
    let weather = Weather(city: "Berlin", temperature: 22, condition: "Sunny", high: 25, low: 14, windSpeed: 12, humidity: 48)
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.blue.opacity(0.15),.white], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text(weather.city)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.yellow)
                    Text("\(weather.temperature)°")
                        .font(.system(size: 80))
                        .fontWeight(.bold)
                    Text(weather.condition)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 40) {
                        VStack {
                            Text("H: \(weather.high)°")
                                .fontWeight(.semibold)
                            Text("High")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack {
                            Text("H: \(weather.low)°")
                                .fontWeight(.semibold)
                            Text("Low")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        WeatherInfoView(icon: "wind", title: "Wind", value: "\(weather.windSpeed)km/h")
                        
                        Spacer()
                        
                        WeatherInfoView(icon: "humidity", title: "Humidity", value: "\(weather.humidity)%")
                    }
                }
                .padding()
            }
            .navigationTitle("Weather")
        }
    }
}

#Preview {
    ContentView()
}
