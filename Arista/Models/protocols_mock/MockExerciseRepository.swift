//
//  MockExerciseRepository.swift
//  Arista
//
//  Created by Yannick LEPLARD on 19/08/2024.
//

import Foundation
import CoreData



class MockExerciseRepository: ExerciseRepositoryProtocol {
    var mockExercises: [Exercise] = []
    
    func getExercise() throws -> [Exercise] {
        return mockExercises
    }
    
    func addExercise(category: String, duration: Int, intensity: Int, startDate: Date) throws {
        // Implement mock behavior if needed
    }
}
