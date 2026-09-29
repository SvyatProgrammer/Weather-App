//
//  ForecastCard.swift
//  Weather App
//
//  Created by Свят on 29.09.26.
//

import SwiftUI

struct ForecastCard: View {
    
    let day : ForecastDay
    
    private var condition : WeatherCondition {
        WeatherCondition.from(code: day.weatherCode)
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text(day.displayDate)
                .font(.caption)
                .foregroundStyle(.secondary)
            Image(systemName: condition.icon)
                .font(.title)
            Text(condition.title)
                .font(.caption)
            
            HStack(spacing: 8) {
                Text("\(Int(day.maxTemperature))°")
                    .fontWeight(.bold)
                Text("\(Int(day.minTemperature))°")
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 130)
        .padding()
        .background(.white.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ForecastCard(day: ForecastDay(date: "2026", maxTemperature: 80, minTemperature: 70, weatherCode: 1))
}
