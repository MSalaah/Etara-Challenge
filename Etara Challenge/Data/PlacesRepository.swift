//
//  PlacesRepository.swift
//  Etara Challenge
//
//  Created by Moe Salah  on 17/12/2025.
//

import Foundation
import CoreLocation

class PlacesRepository: PlacesRepoProtocol {
    //TODO: implement Local data storeage with coredata so the app can work in offline mode.
    
    // 1. Implement Core Data Manager
    // 2. load data from the database in case there is no connection.
    
    // MARK: - Mocked Remote Data
    private let mockRestaurants: [Restaurant] = [
        Restaurant(
            name: "Entrecôte Café de Paris - The Dubai Mall",
            rating: 4.87,
            cuisineType: "African restaurant",
            area: "Jumeriah",
            isOpen: true,
            closingTime: "3AM",
            distance: "300 m",
            coordinate: CLLocationCoordinate2D(latitude: 25.1972, longitude: 55.2744),
            images: ["restaurant1_1", "restaurant1_2", "restaurant1_3"],
            review: "The food and the ambience was amazing",
            categories: ["brunch", "African", "Indian"]
        ),
        Restaurant(
            name: "Akira Back Dubai",
            rating: 4.87,
            cuisineType: "African restaurant",
            area: "Jumeriah",
            isOpen: true,
            closingTime: "3AM",
            distance: "300 m",
            coordinate: CLLocationCoordinate2D(latitude: 25.2100, longitude: 55.2750),
            images: ["restaurant2_1", "restaurant2_2", "restaurant2_3"],
            review: "The food and the ambience was amazing",
            categories: ["brunch", "African", "Indian"]
        ),
        Restaurant(
            name: "Nobu Dubai",
            rating: 4.9,
            cuisineType: "Japanese restaurant",
            area: "Downtown Dubai",
            isOpen: true,
            closingTime: "2AM",
            distance: "450 m",
            coordinate: CLLocationCoordinate2D(latitude: 25.2000, longitude: 55.2800),
            images: ["restaurant3_1", "restaurant3_2", "restaurant3_3"],
            review: "Outstanding experience with exceptional service",
            categories: ["brunch", "Japanese", "Indian"]
        ),
        Restaurant(
            name: "La Petite Maison",
            rating: 4.75,
            cuisineType: "French restaurant",
            area: "DIFC",
            isOpen: true,
            closingTime: "12AM",
            distance: "1.2 km",
            coordinate: CLLocationCoordinate2D(latitude: 25.2150, longitude: 55.2650),
            images: ["restaurant4_1", "restaurant4_2", "restaurant4_3"],
            review: "Authentic French cuisine at its finest",
            categories: ["brunch", "French", "Indian"]
        ),
        Restaurant(
            name: "Zuma Dubai",
            rating: 4.85,
            cuisineType: "Japanese restaurant",
            area: "DIFC",
            isOpen: true,
            closingTime: "1AM",
            distance: "800 m",
            coordinate: CLLocationCoordinate2D(latitude: 25.2080, longitude: 55.2820),
            images: ["restaurant5_1", "restaurant5_2", "restaurant5_3"],
            review: "Contemporary Japanese izakaya dining",
            categories: ["brunch", "Japanese", "Indian"]
        ),
        Restaurant(
            name: "Pierchic",
            rating: 4.92,
            cuisineType: "Seafood restaurant",
            area: "Jumeirah Beach",
            isOpen: true,
            closingTime: "11PM",
            distance: "2.1 km",
            coordinate: CLLocationCoordinate2D(latitude: 25.2180, longitude: 55.2680),
            images: ["restaurant6_1", "restaurant6_2", "restaurant6_3"],
            review: "Stunning waterfront dining experience",
            categories: ["brunch", "Seafood", "Indian"]
        )
    ]

    //Simulate network delay
    private let taskSleepTime: UInt64 = 1_000_000_000
    
    func fetchRestaurants(query: String, location: String) async throws -> [Restaurant] {
        try await Task.sleep(nanoseconds: taskSleepTime)
        
        let lowercasedQuery = query.lowercased()
        if lowercasedQuery.isEmpty {
            return mockRestaurants
        }

        return mockRestaurants.filter { restaurant in
            restaurant.name.lowercased().contains(lowercasedQuery) ||
            restaurant.cuisineType.lowercased().contains(lowercasedQuery) ||
            restaurant.area.lowercased().contains(lowercasedQuery) ||
            restaurant.categories.contains { $0.lowercased().contains(lowercasedQuery) }
        }
    }

    func fetchRestaurantsByFilter(filter: String) async throws -> [Restaurant] {
        try await Task.sleep(nanoseconds: taskSleepTime)

        return mockRestaurants.filter { restaurant in
            restaurant.categories.contains(filter.lowercased())
        }
    }
}
