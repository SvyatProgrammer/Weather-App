import SwiftUI
internal import _LocationEssentials

struct ContentView: View {
    
    @State private var viewModel = WeatherViewModel()
    
    @State private var isShowingSearch = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.blue.opacity(0.15),.white], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        content
                    }
                    .padding(.vertical)
                }
                .navigationTitle("Weather")
                .refreshable {
                    await viewModel.loadWeather(for: viewModel.city)
                }
                .navigationDestination(isPresented: $isShowingSearch) {
                    CitySearchView(viewModel: viewModel)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        searchButton
                    }
                }
            }
        }
        .task {
            await viewModel.loadWeather(for: viewModel.city)
        }
    }
    
    private var searchButton : some View {
        Button {
            isShowingSearch = true
        } label: {
            Image(systemName: "magnifyingglass")
        }
    }
    
    @ViewBuilder
    private var content : some View {
        if viewModel.isLoading {
            ProgressView("Loading...")
        } else if let errorMessage = viewModel.errorMessage {
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
                        await viewModel.loadWeather(for: viewModel.city)
                    }
                }
                .buttonStyle(.glassProminent)
            }
            .padding()
        } else if let weather = viewModel.weather {
            WeatherContent(weather: weather, city: viewModel.city)
        }
    }
}

#Preview {
    ContentView()
}
