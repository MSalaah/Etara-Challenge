//
//  PlacesRepoProtocol.swift
//  Etara Challenge
//
//  Created by Moe Salah  on 17/12/2025.
//

import Foundation

protocol PlacesRepoProtocol {
    func fetchRestaurants(query: String, location: String) async throws -> [Restaurant]
    func fetchRestaurantsByFilter(filter: String) async throws -> [Restaurant]
}
