//
//  UseCaseError.swift
//  Etara Challenge
//
//  Created by Moe Salah  on 17/12/2025.
//

import Foundation

// MARK: - Error Types
enum UseCaseError: LocalizedError {
    case invalidQuery
    case invalidFilter
    case noResultsFound

    var errorDescription: String? {
        switch self {
        case .invalidQuery:
            return "Invalid search query"
        case .invalidFilter:
            return "Please select a valid filter"
        case .noResultsFound:
            return "No restaurants found matching your criteria"
        }
    }
}
