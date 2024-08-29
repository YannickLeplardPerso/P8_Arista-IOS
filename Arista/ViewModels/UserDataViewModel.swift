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

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchUserData()
    }
    
    private func fetchUserData() {
        do {
            guard let user = try UserRepository().getUser() else {
                throw AristaError.noData
            }
            firstName = user.firstName ?? ""
            lastName = user.lastName ?? ""
            
            // temp for debug only : to obtain path for database (for deletion of datas with DB Browser for SQLite)
            #if DEBUG
//            let storeURL = viewContext.persistentStoreCoordinator?.persistentStores.first?.url
//            print(storeURL ?? "No store URL found")
            #endif
            
        } catch let error as AristaError {
            self.error = error
        } catch {
            self.error = .fetchFailed(reason: error.localizedDescription)
        }
    }
}
