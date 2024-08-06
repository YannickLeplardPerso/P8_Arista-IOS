//
//  AddExerciseViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class AddExerciseViewModel: ObservableObject {
    @Published var category: ExerciseCategory = .marche
    @Published var startTime: Date = Date()
    @Published var duration: Int = 0
    @Published var intensity: Int = 0
    
    var durationString: String {
        get {
            return String(duration)
        }
        set {
            if let value = Int(newValue) {
                duration = value
            } else {
                duration = 0
            }
        }
    }
    
    var intensityString: String {
        get {
            return String(intensity)
        }
        set {
            if let value = Int(newValue) {
                intensity = value
            } else {
                intensity = 0
            }
        }
    }
    
    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    
    // Method to convert Date to String
    func getStartTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: startTime)
    }
    
    // Method to convert String to Date and update startTime
    func setStartTime(from string: String) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        if let date = formatter.date(from: string) {
            startTime = date
        }
    }
    
    func addExercise() throws {
        try ExerciseRepository(viewContext: viewContext).addExercise(
            category: category.rawValue,
            duration: duration,
            intensity: intensity,
            startDate: startTime
        )
    }
}
