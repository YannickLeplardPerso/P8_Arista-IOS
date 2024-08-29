//
//  SleepHistoryViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class SleepHistoryViewModel: ObservableObject {
    @Published var sleepSessions = [Sleep]()
    @Published var error: AristaError?
    
    private var viewContext: NSManagedObjectContext
    private var repository: SleepRepository
    
    init(context: NSManagedObjectContext, repository: SleepRepository? = nil) {
        self.viewContext = context
        self.repository = repository ?? SleepRepository(viewContext: context)
        fetchSleepSessions()
    }
    
    private func fetchSleepSessions() {
        do {
            sleepSessions = try repository.getSleepSessions()
        } catch let error as AristaError {
            self.error = error
        } catch {
            self.error = .fetchFailed(reason: error.localizedDescription)
        }
    }
}
