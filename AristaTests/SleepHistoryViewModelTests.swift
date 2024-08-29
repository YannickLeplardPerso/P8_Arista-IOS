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
        // First delete Sleep entities
        let sleepFetchRequest: NSFetchRequest<NSFetchRequestResult> = Sleep.fetchRequest()
        let sleepDeleteRequest = NSBatchDeleteRequest(fetchRequest: sleepFetchRequest)
        try context.execute(sleepDeleteRequest)
        
        // Then delete User entities
        let userFetchRequest: NSFetchRequest<NSFetchRequestResult> = User.fetchRequest()
        let userDeleteRequest = NSBatchDeleteRequest(fetchRequest: userFetchRequest)
        try context.execute(userDeleteRequest)
        
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
}
