//
//  ExerciseListVIewModelTests.swift
//  AristaTests
//
//  Created by Yannick LEPLARD on 12/08/2024.
//

import XCTest
import CoreData
import Combine

@testable import Arista



final class ExerciseListViewModelTests: XCTestCase {
    var persistenceController: PersistenceController!
    
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
    }
    override func tearDownWithError() throws {
        emptyEntities(context: persistenceController.container.viewContext)
    }
    
    func test_WhenNoExerciseIsInDatabase_FetchExercise_ReturnEmptyList() {
        let viewModel = ExerciseListViewModel(context: persistenceController.container.viewContext)
        let expectation = XCTestExpectation(description: "fetch empty list of exercise")
        
        viewModel.$exercises
            .sink { exercises in
                XCTAssert(exercises.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_WhenAddingOneExerciseInDatabase_FEtchExercise_ReturnAListContainingTheExercise() {
        let date = Date()
        addExercice(context: persistenceController.container.viewContext,
                    category: "Football", duration: 10, intensity: 5, startDate: date, userFirstName: "Ericw", userLastName: "Marcus")
        
        let viewModel = ExerciseListViewModel(context: persistenceController.container.viewContext)
        let expectation = XCTestExpectation(description: "fetch empty list of exercise")
        
        viewModel.$exercises
            .sink { exercises in
                XCTAssert(exercises.isEmpty == false)
                XCTAssert(exercises.first?.category == "Football")
                XCTAssert(exercises.first?.duration == 10)
                XCTAssert(exercises.first?.intensity == 5)
                XCTAssert(exercises.first?.startDate == date)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_WhenAddingMultipleExerciseInDatabase_FetchExercise_ReturnAListContainingTheExerciseInTheRightOrder() {
        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))
        
        addExercice(context: persistenceController.container.viewContext,
                    category: "Football",
                    duration: 10,
                    intensity: 5,
                    startDate: date1,
                    userFirstName: "Ericn",
                    userLastName: "Marcusi")
        addExercice(context: persistenceController.container.viewContext,
                    category: "Running",
                    duration: 120,
                    intensity: 1,
                    startDate: date3,
                    userFirstName: "Ericb",
                    userLastName: "Marceau")
        addExercice(context: persistenceController.container.viewContext,
                    category: "Fitness",
                    duration: 30,
                    intensity: 5,
                    startDate: date2,
                    userFirstName: "Frédericp",
                    userLastName: "Marcus")
        
        let viewModel = ExerciseListViewModel(context: persistenceController.container.viewContext)
        let expectation = XCTestExpectation(description: "fetch empty list of exercise")
        
        viewModel.$exercises
            .sink { exercises in
                XCTAssert(exercises.count == 3)
                XCTAssert(exercises[0].category == "Football")
                XCTAssert(exercises[1].category == "Fitness")
                XCTAssert(exercises[2].category == "Running")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest = Exercise.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for exercice in objects {
            context.delete(exercice)
        }
        
        try! context.save()
    }
    private func addExercice(context: NSManagedObjectContext, category: String, duration: Int, intensity: Int, startDate: Date, userFirstName: String, userLastName: String) {
        let newUser = User(context: context)
        newUser.firstName = userFirstName
        newUser.lastName = userLastName
        try! context.save()
        
        let newExercise = Exercise(context: context)
        newExercise.category = category
        newExercise.duration = Int64(duration)
        newExercise.intensity = Int64(intensity)
        newExercise.startDate = startDate
        newExercise.user = newUser
        try! context.save()
    }
}
