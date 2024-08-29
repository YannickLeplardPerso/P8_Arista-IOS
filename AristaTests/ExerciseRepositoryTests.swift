//
//  ExerciseRepositoryTests.swift
//  AristaTests
//
//  Created by Yannick LEPLARD on 06/08/2024.
//

import XCTest
import CoreData
@testable import Arista



final class ExerciseRepositoryTests: XCTestCase {
    
    var persistenceController: PersistenceController!
    var repository: ExerciseRepository!
    
    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        repository = ExerciseRepository(viewContext: persistenceController.container.viewContext)
        try setupDefaultUser()
    }
    
    override func tearDownWithError() throws {
        persistenceController = nil
        repository = nil
    }
    
    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest = Exercise.fetchRequest()
        
        do {
            let exercises = try context.fetch(fetchRequest)
            for exercise in exercises {
                context.delete(exercise)
            }
            try context.save()
        } catch {
            print("Failed to empty entities: \(error.localizedDescription)")
            return
        }
    }
    
    private func setupDefaultUser() throws {
        let context = persistenceController.container.viewContext
        let user = User(context: context)
        user.firstName = "Test"
        user.lastName = "User"
        try context.save()
    }
    
    private func addExercice(context: NSManagedObjectContext, category: String, duration: Int, intensity: Int, startDate: Date, userFirstName: String, userLastName: String) {
        let newUser = User(context: context)
        newUser.firstName = userFirstName
        newUser.lastName = userLastName
        
        // Attempt to save user
        do {
            try context.save()
        } catch {
            print("Failed to save user: \(error.localizedDescription)")
            return
        }
        
        let newExercise = Exercise(context: context)
        newExercise.category = category
        newExercise.duration = Int64(duration)
        newExercise.intensity = Int64(intensity)
        newExercise.startDate = startDate
        newExercise.user = newUser
        
        // Attempt to save exercise
        do {
            try context.save()
        } catch {
            print("Failed to save exercise: \(error.localizedDescription)")
            return
        }
    }
    
    func test_addExercise_InvalidDuration_ThrowsError() {
        let category = "Running"
        let invalidDurations = [0, 4321, -10]
        let intensity = 5
        let startDate = Date()

        for duration in invalidDurations {
            XCTAssertThrowsError(try repository.addExercise(category: category, duration: duration, intensity: intensity, startDate: startDate)) { error in
                guard let aristaError = error as? AristaError else {
                    XCTFail("Expected AristaError but got \(type(of: error))")
                    return
                }
                switch aristaError {
                case .invalidDuration:
                    break // This is what we expect
                default:
                    XCTFail("Expected invalidDuration error but got \(aristaError)")
                }
            }
        }
    }
    
    func test_addExercise_InvalidIntensity_ThrowsError() {
        let category = "Running"
        let duration = 30
        let invalidIntensities = [-1, 11]
        let startDate = Date()

        for intensity in invalidIntensities {
            XCTAssertThrowsError(try repository.addExercise(category: category, duration: duration, intensity: intensity, startDate: startDate)) { error in
                guard let aristaError = error as? AristaError else {
                    XCTFail("Expected AristaError but got \(type(of: error))")
                    return
                }
                switch aristaError {
                case .invalidIntensity:
                    break // This is what we expect
                default:
                    XCTFail("Expected invalidIntensity error but got \(aristaError)")
                }
            }
        }
    }
    
    func test_addExercise_ValidInput_Success() throws {
        let category = "Running"
        let duration = 30
        let intensity = 5
        let startDate = Date()
        
        // Attempt to add a valid exercise
        try repository.addExercise(category: category, duration: duration, intensity: intensity, startDate: startDate)
        
        // Fetch the added exercise to verify
        let exercises = try repository.getExercise()
        XCTAssertEqual(exercises.count, 1)
        let exercise = exercises.first!
        XCTAssertEqual(exercise.category, category)
        XCTAssertEqual(exercise.duration, Int64(duration))
        XCTAssertEqual(exercise.intensity, Int64(intensity))
        XCTAssertEqual(exercise.startDate, startDate)
    }

    func test_WhenNoExerciseIsInDatabase_GetExercise_ReturnEmptyList() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        let data = ExerciseRepository(viewContext: persistenceController.container.viewContext)
        
        do {
            let exercises = try data.getExercise()
            XCTAssertTrue(exercises.isEmpty, "Expected no exercises, but found some.")
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_WhenAddingOneExerciseInDatabase_GetExercise_ReturnAListContainingTheExercise() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        let date = Date()
        addExercice(context: persistenceController.container.viewContext, category: "Football", duration: 10, intensity: 5, startDate: date, userFirstName: "Eric", userLastName: "Marcus")
        
        let data = ExerciseRepository(viewContext: persistenceController.container.viewContext)
        let exercises = try! data.getExercise()
        
        XCTAssert(exercises.isEmpty == false)
        XCTAssert(exercises.first?.category == "Football")
        XCTAssert(exercises.first?.duration == 10)
        XCTAssert(exercises.first?.intensity == 5)
        XCTAssert(exercises.first?.startDate == date)
    }
    
    func test_WhenAddingMultipleExerciseInDatabase_GetExercise_ReturnAListContainingTheExerciseInTheRightOrder() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)

        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))
        
        addExercice(context: persistenceController.container.viewContext,
                    category: "Football",
                    duration: 10,
                    intensity: 5,
                    startDate: date1,
                    userFirstName: "Erica",
                    userLastName: "Marcusi")
        addExercice(context: persistenceController.container.viewContext,
                    category: "Running",
                    duration: 120,
                    intensity: 1,
                    startDate: date3,
                    userFirstName: "Erice",
                    userLastName: "Marceau")
        addExercice(context: persistenceController.container.viewContext,
                    category: "Fitness",
                    duration: 30,
                    intensity: 5,
                    startDate: date2,
                    userFirstName: "Frédericd",
                    userLastName: "Marcus")
        
        let data = ExerciseRepository(viewContext: persistenceController.container.viewContext)
        let exercises = try! data.getExercise()
        
        XCTAssert(exercises.count == 3)
        XCTAssert(exercises[0].category == "Football")
        XCTAssert(exercises[1].category == "Fitness")
        XCTAssert(exercises[2].category == "Running")
    }
}
