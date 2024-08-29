//
//  ExerciseRepositoryProtocol.swift
//  Arista
//
//  Created by Yannick LEPLARD on 19/08/2024.
//

import Foundation
import CoreData

protocol ExerciseRepositoryProtocol {
    func getExercise() throws -> [Exercise]
    func addExercise(category: String, duration: Int, intensity: Int, startDate: Date) throws
}
