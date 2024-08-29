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
    private var userRepository: User?
    
    init(user: User?) {
        userRepository = user
    }

    override func getUser() throws -> User? {
        return userRepository
    }
}
