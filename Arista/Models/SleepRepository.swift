//
//  SleepRepository.swift
//  Arista
//
//  Created by Yannick LEPLARD on 24/07/2024.
//

import Foundation
import CoreData

class SleepRepository {
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    func getSleepSessions() throws -> [Sleep] {
        let request = Sleep.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(SortDescriptor<Sleep>(\.startDate, order: .reverse))]
        
        do {
            let sessions = try viewContext.fetch(request)
            return sessions
        } catch {
            throw AristaError.fetchFailed(reason: error.localizedDescription)
        }
    }
}
