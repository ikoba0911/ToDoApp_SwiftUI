//
//  ToDoListView.swift
//  ToDoApp_SwiftUI (iOS)
//
//  Created by IkkiKobayashi on 2021/02/21.
//

import SwiftUI
import CoreData

struct ToDoListView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(entity: ToDoEntity.entity(),
           sortDescriptors: [NSSortDescriptor(keyPath: \ToDoEntity.time,
                                              ascending: true)],
           animation: .default)
    var todoList: FetchedResults<ToDoEntity>
    
    let category: ToDoEntity.Category
    
    fileprivate func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let entity = todoList[index]
            viewContext.delete(entity)
        }
        do {
            try viewContext.save()
        } catch {
            print("Delete Error. \(offsets)")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(todoList) { todo in
                        // 特定のカテゴリのみ表示する形にする
                        if todo.category == self.category.rawValue {
                            TodoDetailRow(todo: todo, hideIcon: false)
                        }
                    }.onDelete(perform: { indexSet in
                        deleteTask(at: indexSet)
                    })
                }
                QuickNewTaskCell(category: category)
                    .padding()
            }.navigationBarTitle(category.name)
            .navigationBarItems(trailing: EditButton())
        }
    }
}

#if DEBUG
struct TodoList_Previews: PreviewProvider {
    
    static let context = PersistenceController.shared.container.viewContext
    
    static var previews: some View {
        
        ToDoEntity.delete(in: context)
        // デモデータの作成
        ToDoEntity.create(in: context, category: .routine, task: "勉強をする")
        ToDoEntity.create(in: context, category: .healthCare, task: "ランニングをする")
        ToDoEntity.create(in: context, category: .shopping, task: "牛乳を買う")
        
        return ToDoListView(category: .routine).environment(\.managedObjectContext, context)
    }
}
#endif
