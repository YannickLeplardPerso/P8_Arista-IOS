//
//  MockSleepRepository.swift
//  AristaTests
//
//  Created by Yannick LEPLARD on 29/08/2024.
//

import XCTest
import CoreData
@testable import Arista



class MockSleepRepository: SleepRepository {
    //private var shouldThrowError: AristaError?
    var shouldThrowError: AristaError?

//    init(user: User?) {
//        userRepository = user
//    }
    
    override func getSleepSessions() throws -> [Sleep] {
        if let error = shouldThrowError {
            throw error
        }
        return []
    }
}

