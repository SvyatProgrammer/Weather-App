import SwiftUI
internal import _LocationEssentials

struct CitySearchView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var locationManager = LocationManager()
    
    @Bindable var viewModel : WeatherViewModel
    
    @FocusState private var isSearchFocused : Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                searchField
                
                suggesions
                
                Spacer()
            }
            .padding()
            .navigationTitle("Search City")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                isSearchFocused = true
            }
        }
    }
    
    private var searchField : some View {
        HStack(spacing: 8) {
            TextField("Search city...", text: $viewModel.searchText)
                .textFieldStyle(.roundedBorder)
                .focused($isSearchFocused)
                .submitLabel(.search)
                .onChange(of: viewModel.searchText) {
                    viewModel.updateSuggestions()
                }
            
            Button {
                loadWeatherForCurrentLocation()
            } label: {
                Image(systemName: "location.fill")
            }
            .buttonStyle(.glassProminent)
        }
    }
    
    @ViewBuilder
    private var suggesions : some View {
        if viewModel.suggestions.isEmpty {
            ContentUnavailableView("No Cities", systemImage: "magnifingglass", description: Text("Start typing a city name."))
        } else {
            List(viewModel.suggestions) { location in
                Button {
                    selectCity(location)
                } label: {
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                        
                        VStack(alignment: .leading) {
                            Text(location.name)
                                .fontWeight(.medium)
                            
                            if let country = location.country {
                                Text(country)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.glass)
            }
            .listStyle(.plain)
        }
    }
    
    private func selectCity(_ location: LocationResult) {
        viewModel.suggestions = []
        
        Task {
            await viewModel.loadWeather(latitude: location.latitude, longitude: location.longitude, cityName: location.name)
            
            dismiss()
        }
    }
    
    private func loadWeatherForCurrentLocation() {
        Task {
            viewModel.isLoading = true
            viewModel.errorMessage = nil
            
            do {
                let location = try await locationManager.requestLocation()
                
                let cityName = try await locationManager.cityName(from: location)
                
                await viewModel.loadWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, cityName: cityName)
            } catch {
                viewModel.errorMessage = error.localizedDescription
            }
            
            dismiss()
            viewModel.isLoading = false
        }
    }
}

#Preview {
    CitySearchView(viewModel: WeatherViewModel())
}
