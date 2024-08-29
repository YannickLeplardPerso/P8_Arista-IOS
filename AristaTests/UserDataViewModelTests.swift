//
//  UserDataVIewModelTests.swift
//  AristaTests
//
//  Created by Yannick LEPLARD on 12/08/2024.
//

import XCTest
import CoreData
import Combine

@testable import Arista



final class UserDataViewModelTests: XCTestCase {
    var persistenceController: PersistenceController!
    var context: NSManagedObjectContext!
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
    }
    
    override func tearDownWithError() throws {
        try clearDatabase()
    }
    
    private func clearDatabase() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = User.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
        try context.save()
    }
    
    private func addUser(firstName: String, lastName: String) {
        let user = User(context: context)
        user.firstName = firstName
        user.lastName = lastName
        try! context.save()
    }
    
    func test_WhenUserDataIsFetched_SuccessfullySetsProperties() {
        // Arrange
        let user = User(context: context)
        user.firstName = "John"
        user.lastName = "Doe"
        let mockRepository = MockUserRepository(user: user)
        
        let viewModel = UserDataViewModel(context: context, repository: mockRepository)
        let expectation = XCTestExpectation(description: "fetch user data and set properties")
        
        // Act & Assert
        viewModel.$firstName
            .combineLatest(viewModel.$lastName)
            .sink { firstName, lastName in
                XCTAssertEqual(firstName, "John", "First name should be 'John'")
                XCTAssertEqual(lastName, "Doe", "Last name should be 'Doe'")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_WhenFetchUserDataFails_ErrorIsSet() {
        // Arrange
        let mockRepository = MockUserRepository(user: nil)
        let viewModel = UserDataViewModel(context: context, repository: mockRepository)
        let expectation = XCTestExpectation(description: "fetch user data and handle error")
        
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
