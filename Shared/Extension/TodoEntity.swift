//
//  TodoEntity.swift
//  ToDoApp_SwiftUI (iOS)
//
//  Created by IkkiKobayashi on 2021/02/15.
//

import SwiftUI
import CoreData


// MARK: - Function
extension ToDoEntity {
    
    static func create(in managedObjectContext: NSManagedObjectContext,
                       category: Category,
                       task: String,
                       time: Date? = Date()){
        let todo = self.init(context: managedObjectContext)
        print(task)
        todo.time = time
        todo.category = category.rawValue
        todo.task = task
        todo.state = State.todo.rawValue
        todo.id = UUID().uuidString
        
        do {
            try  managedObjectContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    static func delete(in managedObjectContext: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEntity")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try! PersistenceController.shared.container.persistentStoreCoordinator.execute(batchDeleteRequest,
                                                          with: managedObjectContext)
    }
    
    static func getTaskCount(in managedObjectContext: NSManagedObjectContext,
                      category: Category) -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEntity")
        request.predicate = NSPredicate(format: "category == \(category.rawValue)")
        
        do {
            let count = try managedObjectContext.count(for: request)
            return count
        } catch {
            print("Error: \(error.localizedDescription) ")
            return 0
        }
    }
}

// MARK: - enum
extension ToDoEntity {
    
    enum Category: Int16 {
        case routine
        case shopping
        case healthCare
        
        var name: String {
            switch self {
            case .routine:
                return "習慣"
            case .shopping:
                return "買い物リスト"
            case .healthCare:
                return "健康維持"
            }
        }
        
        var imageName: String {
            switch self {
            case .routine:
                return "list.dash"
            case .shopping:
                return "cart"
            case .healthCare:
                return "figure.walk"
            }
        }
        
        var color: Color {
            switch self {
            case .routine:
                return Color.yellow
            case .shopping:
                return Color.blue
            case .healthCare:
                return Color.red
            }
        }
    }
    
    enum State: Int16 {
        case todo
        case done
    }
}



