//
//  ExerciseRepository.swift
//  Arista
//
//  Created by Yannick LEPLARD on 24/07/2024.
//

import Foundation
import CoreData

struct ExerciseRepository {
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    func getExercise() throws -> [Exercise] {
        let request = Exercise.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(SortDescriptor<Exercise>(\.startDate, order: .reverse))]
        
        return try viewContext.fetch(request)
    }
    
    func addExercise(category: String, duration: Int, intensity: Int, startDate: Date) throws {
        let newExercise = Exercise(context: viewContext)
        newExercise.category = category
        newExercise.duration = Int64(duration)
        newExercise.intensity = Int64(intensity)
        newExercise.startDate = startDate
        
        try viewContext.save()
    }
    
    func addExercise() {
        
    }
}
