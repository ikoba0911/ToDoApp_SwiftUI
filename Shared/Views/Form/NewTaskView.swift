//
//  NewTaskView.swift
//  ToDoApp_SwiftUI
//
//  Created by IkkiKobayashi on 2021/02/25.
//

import SwiftUI

struct NewTaskView: View {
    
    // MARK: - Property
    @State private var task: String = ""
    @State private var time: Date? = Date()
    @State private var showingSheet = false
    @State private var showingAlert = false
    @State var category: Int16 = ToDoEntity.Category.routine.rawValue
    
    var categories: [ToDoEntity.Category] = [.routine, .shopping, .healthCare]
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - View
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task".localized)) {
                    TextField("InputTask".localized, text: $task)
                }
                
                Section(header: Toggle(isOn: Binding(isNotNil: $time, defaultValue: Date())) {
                    Text("ScheduledTime".localized)
                }) {
                    if isDateExist(date: time) {
                        DatePicker(selection: Binding(source: $time, defaultValue: Date()),
                                   label: { Text("") } )
                    } else {
                        Text("TimeNotSet".localized)
                    }
                }
                
                Section(header: Text("Category".localized)) {
                    Picker(selection: $category, label: Text("")) {
                        ForEach(categories, id: \.self) { category in
                            HStack {
                                CategoryImage(category: category)
                                Text(category.name)
                            }.tag(category.rawValue)
                        }
                    }
                }
                
                Section(header: Text("AddTask".localized)) {
                    Button(action: {
                        if task == "" {
                            self.showingAlert = true
                            return
                        }
                        self.showingSheet = true
                    }) {
                        HStack(alignment: .center) {
                            Image(systemName: "pencil.circle.fill")
                            Text("Create".localized)
                        }
                    }.alert(isPresented: $showingAlert) {
                        Alert(title: Text("NoTaskAlertTitle".localized),
                              message: Text("NoTaskAlertMessage".localized),
                              dismissButton: .default(Text("OK".localized)))
                    }
                }
            }.navigationTitle("AddTaskViewTitle".localized)
            .foregroundColor(Color("label"))
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Close".localized)
                    .foregroundColor(Color("label"))
            })
            .actionSheet(isPresented: $showingSheet) {
                ActionSheet(title: Text("AddTaskActionSheetTitle".localized), message: Text("AddTaskActionSheetMessage".localized), buttons: [
                    .destructive(Text("Add".localized)) {
                        ToDoEntity.create(in: viewContext,
                                          category: ToDoEntity.Category(rawValue: self.category) ?? .routine,
                                          task: self.task,
                                          time: self.time)
                        self.save()
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    .cancel(Text("Cancel".localized))
                ])
            }
        }
    }
}

// MARK: - Function
extension NewTaskView {
    
    private func isDateExist(date: Date?) -> Bool {
        return date != nil
    }
    
    private func save() {
        do {
            try self.viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

#if DEBUG
struct NewTaskView_Previews: PreviewProvider {
    static let context = PersistenceController.shared.container.viewContext
    static var previews: some View {
        NewTaskView().environment(\.managedObjectContext, context)
    }
}
#endif
