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
    
    static func create(in context: NSManagedObjectContext,
                       category: Category,
                       task: String,
                       time: Date? = Date()){
        let entity = self.init(context: context)
        print(task)
        entity.time = time
        entity.category = category.rawValue
        entity.task = task
        entity.state = State.todo.rawValue
        entity.id = UUID().uuidString
        
        do {
            try context.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    static func deleteAllEntity(in context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<ToDoEntity>(entityName: "ToDoEntity")
        do {
            let entityList = try context.fetch(fetchRequest)
            for entity in entityList {
                context.delete(entity)
            }
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    static func deleteSingleCategoryEntity(in context: NSManagedObjectContext, category: Category) {
        let fetchRequest = NSFetchRequest<ToDoEntity>(entityName: "ToDoEntity")
        do {
            let entityList = try context.fetch(fetchRequest)
            for entity in entityList {
                if entity.category == category.rawValue {
                    context.delete(entity)
                }
            }
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    static func deleteBatch(in context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try PersistenceController.shared.container.persistentStoreCoordinator.execute(deleteRequest, with: context)
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    static func getTaskCount(in managedObjectContext: NSManagedObjectContext,
                      category: Category) -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoEntity")
        request.predicate = NSPredicate(format: "category == \(category.rawValue)")
        
        do {
            let count = try managedObjectContext.count(for: request)
            return count
        } catch {
            print("Error: \(error.localizedDescription) ")
            return 0
        }
    }
    
    static func createDemoData(in context: NSManagedObjectContext) {
        let categories: [Category] = [.routine, .healthCare, .shopping]
        let tasks: [String] = ["勉強をする", "ランニングをする", "牛乳を買う"]
        zip(categories, tasks).forEach { create(in: context, category: $0, task: $1) }
        do {
            try context.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    static func createDemoEntity(in context: NSManagedObjectContext,
                                 category: Category,
                                 task: String,
                                 state: State,
                                 time: Date? = Date()) -> ToDoEntity {
        let entity = ToDoEntity(context: context)
        entity.category = category.rawValue
        entity.task = task
        entity.state = state.rawValue
        entity.time = time
        return entity
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



