//
//  EditTaskView.swift
//  ToDoApp_SwiftUI
//
//  Created by IkkiKobayashi on 2021/02/25.
//

import SwiftUI

struct EditTaskView: View {
    @ObservedObject var todo: ToDoEntity
    @State var showingSheet = false
    var categories: [ToDoEntity.Category] = [.routine, .shopping, .healthCare]
    @Environment(\.managedObjectContext) var viewContext
    
    fileprivate func save() {
        do {
            try  self.viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    fileprivate func delete() {
        viewContext.delete(todo)
        save()
    }

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Task".localized)) {
                TextField("InputTask".localized, text: Binding(source: $todo.task, defaultValue: ""))
            }
            
            Section(header: Toggle(isOn: Binding(isNotNil: $todo.time, defaultValue: Date())){Text("ScheduledTime".localized)}) {
                if todo.time != nil {
                    DatePicker(selection: Binding(source: $todo.time, defaultValue: Date()), label: { Text("") })
                } else {
                    Text("TimeNotSet".localized).foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("Category".localized)) {
                Picker(selection: $todo.category, label: Text("")) {
                    ForEach(categories, id: \.self) { category in
                        HStack {
                            CategoryImage(category: category)
                            Text(category.name)
                        }.tag(category.rawValue)
                    }
                }
            }
            
            Section(header: Text("DeleteTask".localized)) {
                Button(action: {
                    self.showingSheet = true
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: "minus.circle.fill")
                        Text("Delete")
                    }.foregroundColor(.red)
                }
            }
        }.navigationBarTitle("EditTaskViewTitle".localized)
        .foregroundColor(Color("label"))
        .navigationBarItems(trailing: Button(action: {
            self.save()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Save".localized)
        })
        .actionSheet(isPresented: $showingSheet) {
            ActionSheet(title: Text("DeleteTaskActionSheetTitle".localized), message: Text("DeleteTaskActionSheetMessage".localized), buttons: [
                .destructive(Text("Delete".localized)) {
                    self.delete()
                    self.presentationMode.wrappedValue.dismiss()
                },
                .cancel(Text("Cancel".localized))
            ])
        }
    }
}

#if DEBUG
struct EditTaskView_Previews: PreviewProvider {
    static let context = PersistenceController.shared.container.viewContext
    static var previews: some View {
        let newTodo = ToDoEntity(context: context)
        return NavigationView {
            EditTaskView(todo: newTodo)
            .environment(\.managedObjectContext, context)
        }
    }
}
#endif
