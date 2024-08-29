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
}
