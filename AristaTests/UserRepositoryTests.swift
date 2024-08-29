//
//  UserRepositoryTests.swift
//  AristaTests
//
//  Created by Yannick LEPLARD on 06/08/2024.
//

import XCTest
import CoreData
@testable import Arista

final class UserRepositoryTests: XCTestCase {

    var persistenceController: PersistenceController!
    var userRepository: UserRepository!

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        userRepository = UserRepository(viewContext: persistenceController.container.viewContext)
        try emptyEntities()
    }

    override func tearDownWithError() throws {
        try emptyEntities()
        persistenceController = nil
        userRepository = nil
    }

    private func emptyEntities() throws {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let users = try persistenceController.container.viewContext.fetch(fetchRequest)
        users.forEach { persistenceController.container.viewContext.delete($0) }
        try persistenceController.container.viewContext.save()
    }

    private func addUser(firstName: String, lastName: String) throws {
        let context = persistenceController.container.viewContext
        let user = User(context: context)
        user.firstName = firstName
        user.lastName = lastName
        try context.save()
    }

    func test_getUser_WhenNoUserExists_ReturnsNil() throws {
        try emptyEntities()
        XCTAssertNil(try userRepository.getUser())
    }

    func test_getUser_WhenUserExists_ReturnsUser() throws {
        try addUser(firstName: "John", lastName: "Doe")
        let user = try userRepository.getUser()
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.firstName, "John")
        XCTAssertEqual(user?.lastName, "Doe")
    }
}
