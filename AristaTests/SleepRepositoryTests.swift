//
//  SleepRepositoryTests.swift
//  AristaTests
//
//  Created by Yannick LEPLARD on 06/08/2024.
//

import XCTest
import CoreData
import Combine

@testable import Arista



final class SleepRepositoryTests: XCTestCase {
    
    var persistenceController: PersistenceController!
    var context: NSManagedObjectContext!
    
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
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Sleep.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
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
        let repository = SleepRepository(viewContext: context)
        
        do {
            let sleepSessions = try repository.getSleepSessions()
            XCTAssertTrue(sleepSessions.isEmpty, "Expected an empty list when no sleep sessions exist in the database")
        } catch {
            XCTFail("Fetching sleep sessions failed with error: \(error)")
        }
    }
}
