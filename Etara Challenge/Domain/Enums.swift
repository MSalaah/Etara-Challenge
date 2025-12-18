//
//  Enums.swift
//  Etara Challenge
//
//  Created by Moe Salah  on 17/12/2025.
//

import Foundation

// MARK: - Pure Swift Models for UI State
enum SheetDetent {
    case small
    case medium
    case large
}

struct MapRegion {
    var centerLatitude: Double
    var centerLongitude: Double
    var latitudeDelta: Double
    var longitudeDelta: Double

    init(centerLatitude: Double, centerLongitude: Double, latitudeDelta: Double = 0.05, longitudeDelta: Double = 0.05) {
        self.centerLatitude = centerLatitude
        self.centerLongitude = centerLongitude
        self.latitudeDelta = latitudeDelta
        self.longitudeDelta = longitudeDelta
    }
}
