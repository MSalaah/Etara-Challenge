//
//  PlacesUseCase.swift
//  Etara Challenge
//
//  Created by Moe Salah  on 17/12/2025.
//

import Foundation

class PlacesUseCase {
    
    private let repository: PlacesRepoProtocol

    init(repository: PlacesRepoProtocol) {
        self.repository = repository
    }

    // MARK: - Business Logic
    func searchRestaurants(query: String, location: String) async throws -> [Restaurant] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw UseCaseError.invalidQuery
        }

        let restaurants = try await repository.fetchRestaurants(query: query, location: location)

        return restaurants.sorted { $0.rating > $1.rating }
    }

    func getRestaurantsByFilter(filter: String) async throws -> [Restaurant] {
        guard !filter.isEmpty else {
            throw UseCaseError.invalidFilter
        }
        
        let restaurants = try await repository.fetchRestaurantsByFilter(filter: filter)

        return restaurants.sorted { $0.rating > $1.rating }
    }

    func getAllRestaurants() async throws -> [Restaurant] {
        let restaurants = try await repository.fetchRestaurants(query: "", location: "")
        
        return restaurants.sorted { $0.rating > $1.rating }
    }
}
