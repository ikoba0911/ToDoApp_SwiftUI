//
//  ToDoListView.swift
//  ToDoApp_SwiftUI (iOS)
//
//  Created by IkkiKobayashi on 2021/02/21.
//

import SwiftUI
import CoreData

struct ToDoListView: View {
    
    // MARK: - Property
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(entity: ToDoEntity.entity(),
           sortDescriptors: [NSSortDescriptor(keyPath: \ToDoEntity.time,
                                              ascending: true)],
           animation: .default)
    
    var todoList: FetchedResults<ToDoEntity>
    let category: ToDoEntity.Category
    
    // MARK: - View
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(todoList) { todo in
                        if todo.category == self.category.rawValue {
                            NavigationLink(destination: EditTaskView(todo: todo)) {
                                TodoDetailCell(todo: todo, hideIcon: false)
                            }
                        }
                    }.onDelete(perform: { indexSet in
                        deleteTask(at: indexSet)
                    })
                }
                QuickNewTaskCell(category: category)
                    .padding()
            }.navigationBarTitle(category.name)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Close".localized)
                    .foregroundColor(Color("label"))
            }, trailing: Button(action: {
                ToDoEntity.deleteSingleCategoryEntity(in: viewContext, category: category)
            }) {
                HStack {
                    Image(systemName: "trash")
                        .foregroundColor(Color("label"))
                    Text("AllTaskDelete".localized)
                        .foregroundColor(Color("label"))
                }
            })
        }
    }
}

// MARK: - Function
extension ToDoListView {
    
    private func deleteTask(at offsets: IndexSet) {
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
}

#if DEBUG
struct TodoListView_Previews: PreviewProvider {
    
    static let context = PersistenceController.shared.container.viewContext
    
    static var previews: some View {
        ToDoEntity.deleteBatch(in: context)
        ToDoEntity.createDemoData(in: context)
        return ToDoListView(category: .routine).environment(\.managedObjectContext, context)
    }
}
#endif
