//
//  AristaError.swift
//  Arista
//
//  Created by Yannick LEPLARD on 05/08/2024.
//

import Foundation



enum AristaError: Error, LocalizedError, Equatable {
    case noData
    case fetchFailed(reason: String)
//    case invalidCategory
    case invalidDuration
    case invalidIntensity
    
    // temp : for Persistence (CoreData)
    case persistentStoreLoadingFailed(reason: String)
    case defaultDataApplicationFailed(reason: String)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .noData:
            return "No data available"
        case .fetchFailed(let reason):
            return "Failed to fetch data: \(reason)"
//        case .invalidCategory:
//            return "This category is not supported (or doesn't exist)."
        case .invalidDuration:
            return "The duration must be between 1 and 4320 minutes (3 days)."
        case .invalidIntensity:
            return "The intensity must be between 0 and 10."
        // temp : for Persistence (CoreData)
        case .persistentStoreLoadingFailed(let reason):
            return "Persistent store loading failed: \(reason)"
        case .defaultDataApplicationFailed(let reason):
            return "Failed to apply default data: \(reason)"
        case .unknownError:
            return "An unknown error occurred"
        }
    }
}
