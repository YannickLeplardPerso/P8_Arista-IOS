//
//  AddExerciseVIewModelTests.swift
//  AristaTests
//
//  Created by Yannick LEPLARD on 12/08/2024.
//

import XCTest
import CoreData
@testable import Arista

final class AddExerciseViewModelTests: XCTestCase {
    var persistenceController: PersistenceController!
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
    }
    
    override func tearDownWithError() throws {
        try clearDatabase()
    }
    
    private func clearDatabase() throws {
        // Delete Exercise entities first
        let exerciseFetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        let exercises = try context.fetch(exerciseFetchRequest)
        
        for exercise in exercises {
            context.delete(exercise)
        }
        
        // Delete User entities
        let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let users = try context.fetch(userFetchRequest)
        
        for user in users {
            context.delete(user)
        }
        
        try context.save()
    }

    
    // Helper methods for test setup
    private func addUser(firstName: String, lastName: String) -> User {
        let newUser = User(context: context)
        newUser.firstName = firstName
        newUser.lastName = lastName
        try! context.save()
        return newUser
    }

    private func addExercise(viewModel: AddExerciseViewModel, user: User) {
        try! context.performAndWait {
            let newExercise = Exercise(context: context)
            newExercise.category = viewModel.category.rawValue
            newExercise.duration = Int64(viewModel.duration)
            newExercise.intensity = Int64(viewModel.intensity)
            newExercise.startDate = viewModel.startTime
            newExercise.user = user
            
            try context.save()
        }
    }
    
    func test_DurationStringConversion() {
        let viewModel = AddExerciseViewModel(context: context)
        
        // Test initial value
        XCTAssertEqual(viewModel.durationString, "0")
        
        // Test setting a valid value
        viewModel.durationString = "45"
        XCTAssertEqual(viewModel.duration, 45)
        XCTAssertEqual(viewModel.durationString, "45")
        
        // Test setting an invalid value
        viewModel.durationString = "invalid"
        XCTAssertEqual(viewModel.duration, 0)
        XCTAssertEqual(viewModel.durationString, "0")
    }
    
    func test_IntensityStringConversion() {
        let viewModel = AddExerciseViewModel(context: context)
        
        // Test initial value
        XCTAssertEqual(viewModel.intensityString, "0")
        
        // Test setting a valid value
        viewModel.intensityString = "7"
        XCTAssertEqual(viewModel.intensity, 7)
        XCTAssertEqual(viewModel.intensityString, "7")
        
        // Test setting an invalid value
        viewModel.intensityString = "invalid"
        XCTAssertEqual(viewModel.intensity, 0)
        XCTAssertEqual(viewModel.intensityString, "0")
    }
    
    func test_GetStartTimeString() {
        let viewModel = AddExerciseViewModel(context: context)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        // Test initial value
        let expectedStartTimeString = formatter.string(from: viewModel.startTime)
        XCTAssertEqual(viewModel.getStartTimeString(), expectedStartTimeString)
        
        // Test after changing the start time
        let newDate = Date(timeIntervalSinceNow: 3600)
        viewModel.startTime = newDate
        XCTAssertEqual(viewModel.getStartTimeString(), formatter.string(from: newDate))
    }
    
    func test_SetStartTimeFromString() {
        let viewModel = AddExerciseViewModel(context: context)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        // Test setting a valid date string
        let validDateString = formatter.string(from: Date())
        viewModel.setStartTime(from: validDateString)
        XCTAssertEqual(viewModel.startTime, formatter.date(from: validDateString))
        
        // Test setting an invalid date string
        let invalidDateString = "invalid"
        viewModel.setStartTime(from: invalidDateString)
        XCTAssertNotEqual(viewModel.startTime, formatter.date(from: invalidDateString))
    }
    
    func test_WhenAddingExercise_ExerciseIsAddedToDatabase() {
        let user = addUser(firstName: "John", lastName: "Doe")
        
        let viewModel = AddExerciseViewModel(context: context)
        viewModel.category = .football
        viewModel.duration = 60
        viewModel.intensity = 4
        
        addExercise(viewModel: viewModel, user: user)
        
        let fetchRequest = Exercise.fetchRequest()
        let exercises = try! context.fetch(fetchRequest)
        
        XCTAssertEqual(exercises.count, 1)
        XCTAssertEqual(exercises.first?.category, "Football")
        XCTAssertEqual(exercises.first?.duration, 60)
        XCTAssertEqual(exercises.first?.intensity, 4)
        XCTAssertEqual(exercises.first?.user?.firstName, "John")
        XCTAssertEqual(exercises.first?.user?.lastName, "Doe")
    }
    
    //yl
    func test_invalidStartTimeConversion() {
        let viewModel = AddExerciseViewModel(context: context)

        // Test invalid date strings
        let invalidDateStrings = ["invalid", "2024-02-30", "2024-13-01"]
        for dateString in invalidDateStrings {
            viewModel.setStartTime(from: dateString)
            XCTAssertNotEqual(viewModel.startTime, DateFormatter().date(from: dateString))
        }
    }
    
    func test_setStartTime_WithEdgeCases() {
        let viewModel = AddExerciseViewModel(context: context)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        // Test very old date
        let oldDate = Date(timeIntervalSince1970: 0)
        viewModel.startTime = oldDate
        XCTAssertEqual(viewModel.getStartTimeString(), formatter.string(from: oldDate))

        // Test very future date
        let futureDate = Date(timeIntervalSinceNow: 10000000000)
        viewModel.startTime = futureDate
        XCTAssertEqual(viewModel.getStartTimeString(), formatter.string(from: futureDate))
    }
}
