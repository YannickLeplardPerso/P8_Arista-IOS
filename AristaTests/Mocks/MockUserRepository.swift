//
//  MockUserRepository.swift
//  AristaTests
//
//  Created by Yannick LEPLARD on 29/08/2024.
//

import XCTest
import CoreData
@testable import Arista


class MockUserRepository: UserRepository {
    var shouldReturnUser: User?
    var shouldThrowError: AristaError?

    override func getUser() throws -> User? {
        if let error = shouldThrowError {
            throw error
        }
        return shouldReturnUser
    }
}
