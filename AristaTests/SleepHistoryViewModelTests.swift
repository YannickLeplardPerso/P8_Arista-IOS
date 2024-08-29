//
//  SleepHistoryVIewModelTests.swift
//  AristaTests
//
//  Created by Yannick LEPLARD on 12/08/2024.
//

import XCTest
import CoreData
import Combine

@testable import Arista

final class SleepHistoryViewModelTests: XCTestCase {
    
    var persistenceController: PersistenceController!
    var context: NSManagedObjectContext!
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Initialize an in-memory Core Data stack for testing
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
    }
    
    override func tearDownWithError() throws {
        // Clear the database after each test
        try clearDatabase()
    }
    
    private func clearDatabase() throws {
        // Delete Sleep entities first
        let sleepFetchRequest: NSFetchRequest<Sleep> = Sleep.fetchRequest()
        let sleepSessions = try context.fetch(sleepFetchRequest)
        
        for sleep in sleepSessions {
            context.delete(sleep)
        }
        
        // Delete User entities after Sleep entities have been removed
        let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let users = try context.fetch(userFetchRequest)
        
        for user in users {
            context.delete(user)
        }
        
        try context.save()
    }
    
    private func addUser(firstName: String, lastName: String) -> User {
        let user = User(context: context)
        user.firstName = firstName
        user.lastName = lastName
        try! context.save()
        return user
    }
    
    private func addSleepSession(duration: Int64, quality: Int64, startDate: Date, user: User) {
        let sleepSession = Sleep(context: context)
        sleepSession.duration = duration
        sleepSession.quality = quality
        sleepSession.startDate = startDate
        sleepSession.user = user
        try! context.save()
    }
    
    func test_WhenNoSleepSessionInDatabase_FetchSleepSessions_ReturnsEmptyList() {
        let viewModel = SleepHistoryViewModel(context: context)
        let expectation = XCTestExpectation(description: "fetch empty list of sleep sessions")
        
        viewModel.$sleepSessions
            .sink { sleepSessions in
                XCTAssertTrue(sleepSessions.isEmpty, "Expected an empty list when no sleep sessions exist in the database")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_WhenSleepSessionsExistInDatabase_FetchSleepSessions_ReturnsSleepSessionsList() {
        // Arrange: Add a user and sleep session
        let user = addUser(firstName: "John", lastName: "Doe")
        addSleepSession(duration: 480, quality: 4, startDate: Date(), user: user)
        
        let viewModel = SleepHistoryViewModel(context: context)
        let expectation = XCTestExpectation(description: "fetch list of sleep sessions")
        
        // Act & Assert: Check that the sleep sessions list is populated
        viewModel.$sleepSessions
            .sink { sleepSessions in
                XCTAssertEqual(sleepSessions.count, 1, "Expected one sleep session in the list")
                XCTAssertEqual(sleepSessions.first?.duration, 480, "Expected the duration to match the added sleep session")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_WhenFetchingSleepSessionsFails_ErrorIsSet() {
        // Arrange
        let mockRepository = MockSleepRepository(viewContext: context)
        mockRepository.shouldThrowError = AristaError.noData 
        let viewModel = SleepHistoryViewModel(context: context, repository: mockRepository)
        let expectation = XCTestExpectation(description: "fetch sleep sessions and handle error")
        
        // Act & Assert
        viewModel.$error
            .sink { error in
                XCTAssertEqual(error, .noData)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
}
