//
//  MapViewModel.swift
//  Etara Challenge
//
//  Created by Moe Salah  on 17/12/2025.
//

import Foundation
import CoreLocation

final class MapViewModel: ObservableObject {
    // MARK: - Dependencies
    private let useCase: PlacesUseCase

    // MARK: - Published Properties
    @Published private(set) var allResults: [Place] = []
    @Published var results: [Place] = []
    @Published var restaurants: [Restaurant] = []
    @Published var selectedRestaurant: Restaurant?

    @Published var showResultsSheet = true
    @Published var sheetDetent: SheetDetent = .small

    @Published var query: String = ""
    @Published var location: String = "Dubai - United Arab Emirates"

    @Published var filters: [Filter] = []
    @Published var selectedFilter: Filter?
    @Published var selectedPlace: Place?

    @Published var isLoading = false
    @Published var errorMessage: String?

    @Published var region: MapRegion = MapRegion(
        centerLatitude: 25.2048,
        centerLongitude: 55.2708
    )

    // MARK: - Public Methods for View Layer
    func updateRegionCenter(latitude: Double, longitude: Double) {
        region.centerLatitude = latitude
        region.centerLongitude = longitude
    }

    func updateRegionCenter(coordinate: CLLocationCoordinate2D) {
        region.centerLatitude = coordinate.latitude
        region.centerLongitude = coordinate.longitude
    }
    
    // MARK: - Initialization
    init(useCase: PlacesUseCase = PlacesUseCase(repository: PlacesRepository())) {
        self.useCase = useCase

        // Initialize filters
        filters = [
            Filter(title: "Sort", icon: "arrow.up.arrow.down", hasDropdown: false),
            Filter(title: "Cuisines", icon: nil, hasDropdown: true),
            Filter(title: "brunch", icon: nil, hasDropdown: false),
            Filter(title: "Distance", icon: nil, hasDropdown: true),
            Filter(title: "Rating 4.0+", icon: nil, hasDropdown: false)
        ]

        // Set "brunch" as default selected filter
        selectedFilter = filters.first { $0.title == "brunch" }

        // Load initial data
        Task {
            await loadRestaurants()
        }
    }

    func search() {
        Task {
            await performSearch()
        }
    }

    @MainActor
    private func loadRestaurants() async {
        isLoading = true
        errorMessage = nil

        do {
            if let filter = selectedFilter {
                restaurants = try await useCase.getRestaurantsByFilter(filter: filter.title)
            } else {
                restaurants = try await useCase.searchRestaurants(query: query, location: location)
            }
            updatePlacesFromRestaurants()
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            print("Error loading restaurants: \(error)")
        }
    }

    @MainActor
    private func performSearch() async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        isLoading = true
        errorMessage = nil

        do {
            restaurants = try await useCase.searchRestaurants(query: query, location: location)

            // Apply client-side filtering if a filter is selected
            if let filter = selectedFilter {
                restaurants = restaurants.filter { restaurant in
                    restaurant.categories.contains(filter.title.lowercased())
                }
            }

            updatePlacesFromRestaurants()
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            print("Error searching restaurants: \(error)")
        }
    }

    @MainActor
    private func applyFilters() async {
        isLoading = true
        errorMessage = nil

        do {
            if let selectedFilter = selectedFilter {
                restaurants = try await useCase.getRestaurantsByFilter(filter: selectedFilter.title)
            } else {
                restaurants = try await useCase.getAllRestaurants()
            }

            updatePlacesFromRestaurants()
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            print("Error applying filters: \(error)")
        }
    }

    private func updatePlacesFromRestaurants() {
        allResults = restaurants.map { restaurant in
            Place(
                name: restaurant.name,
                subtitle: restaurant.cuisineType,
                coordinate: restaurant.coordinate,
                categories: restaurant.categories
            )
        }
        results = allResults
    }

    func selectRestaurant(_ restaurant: Restaurant) {
        selectedRestaurant = restaurant
        sheetDetent = .small
    }
    
    func toggleFilter(_ filter: Filter) {
        // Clear selected restaurant when changing filters
        selectedRestaurant = nil

        // Reset sheet to show list view
        sheetDetent = .medium

        // If empty filter (clear button clicked), clear the filter
        if filter.title.isEmpty {
            selectedFilter = nil
        }
        // If the same filter is clicked again, deselect it
        else if selectedFilter?.id == filter.id {
            selectedFilter = nil
        } else {
            selectedFilter = filter
        }

        // Apply the filter change
        Task {
            await applyFilters()
        }
    }

    func clearFilter() {
        selectedRestaurant = nil
        selectedFilter = nil
        sheetDetent = .medium

        Task {
            await applyFilters()
        }
    }
}
