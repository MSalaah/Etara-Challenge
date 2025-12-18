//
//  Restaurant.swift
//  Etara Challenge
//
//  Created by Moe Salah  on 17/12/2025.
//

import Foundation
import MapKit

// MARK: - Models
struct Restaurant: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let rating: Double
    let cuisineType: String
    let area: String
    let isOpen: Bool
    let closingTime: String
    let distance: String
    let coordinate: CLLocationCoordinate2D
    let images: [String]
    let review: String
    let categories: [String]

    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        lhs.id == rhs.id
    }
}
struct Place: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let subtitle: String
    let coordinate: CLLocationCoordinate2D
    let categories: [String]

    static func == (lhs: Place, rhs: Place) -> Bool {
        lhs.id == rhs.id
    }
}

struct Filter: Identifiable {
    let id = UUID()
    let title: String
    let icon: String?
    let hasDropdown: Bool

    init(title: String, icon: String? = nil, hasDropdown: Bool = false) {
        self.title = title
        self.icon = icon
        self.hasDropdown = hasDropdown
    }
}
