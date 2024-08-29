//
//  ExerciseRepository.swift
//  Arista
//
//  Created by Yannick LEPLARD on 24/07/2024.
//

import Foundation
import CoreData



//struct ExerciseRepository {
class ExerciseRepository {
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    func getExercise() throws -> [Exercise] {
        let request = Exercise.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(SortDescriptor<Exercise>(\.startDate, order: .reverse))]
        
        do {
            let exercises = try viewContext.fetch(request)
            return exercises
        } catch {
            throw AristaError.fetchFailed(reason: error.localizedDescription)
        }
    }
    
//    private func checkCategory(category: String) -> Bool {
//        return ExerciseCategory(rawValue: category) != nil
//    }
    
    private func checkDurationValidity(duration: Int) -> Bool {
        // duration must not exceed 3 days = 72 hours !
        return duration >= 1 && duration <= 4320
    }
    
    private func checkIntensityValidity(intensity: Int) -> Bool {
        // 0 <= intensity <= 10
        return intensity >= 0 && intensity <= 10
    }
    
    func addExercise(category: String, duration: Int, intensity: Int, startDate: Date) throws {
//        guard checkCategory(category: String) else {
//            throw AristaError.invalidCategory
//        }
        guard checkDurationValidity(duration: duration) else {
            throw AristaError.invalidDuration
        }
        guard checkIntensityValidity(intensity: intensity) else {
            throw AristaError.invalidIntensity
        }
        
        let newExercise = Exercise(context: viewContext)
        newExercise.category = category
        newExercise.duration = Int64(duration)
        newExercise.intensity = Int64(intensity)
        
        
        newExercise.startDate = startDate
        
        // user not optional in the data model
        newExercise.user = try UserRepository(viewContext: viewContext).getUser()
        
        try viewContext.save()
    }
}
