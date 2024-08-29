//
//  UserDataViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class UserDataViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var error: AristaError?

    private var viewContext: NSManagedObjectContext
    private var userRepository: UserRepository

    init(context: NSManagedObjectContext, repository: UserRepository = UserRepository()) {
        self.viewContext = context
        self.userRepository = repository
        fetchUserData()
    }
    
    private func fetchUserData() {
        do {
            guard let user = try userRepository.getUser() else {
                throw AristaError.noData
            }
            firstName = user.firstName ?? ""
            lastName = user.lastName ?? ""
            
            // to obtain path for database (for deletion of datas with DB Browser for SQLite)
            #if DEBUG
            let storeURL = viewContext.persistentStoreCoordinator?.persistentStores.first?.url
            print(storeURL ?? "No store URL found")
            #endif
            
        } catch let error as AristaError {
            self.error = error
        } catch {
            self.error = .fetchFailed(reason: error.localizedDescription)
        }
    }
}
