//
//  ExerciseListViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData



class ExerciseListViewModel: ObservableObject {
    @Published var exercises = [Exercise]()
    @Published var error: AristaError?

    private var repository: ExerciseRepository
    var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext, repository: ExerciseRepository? = nil) {
        self.viewContext = context
        self.repository = repository ?? ExerciseRepository(viewContext: viewContext)
        fetchExercises()
    }

    
    // private
    func fetchExercises() {
        do {
            exercises = try repository.getExercise()
        } catch let error as AristaError {
            self.error = error
        } catch {
            self.error = .fetchFailed(reason: error.localizedDescription)
        }
    }
    
    // to update exercises when dismiss the addExerciceView
    func reload() {
        fetchExercises()
    }
}
