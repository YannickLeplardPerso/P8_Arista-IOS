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

    var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchExercises()
    }

    private func fetchExercises() {
        do {
            let data = ExerciseRepository(viewContext: viewContext)
            exercises = try data.getExercise()
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
