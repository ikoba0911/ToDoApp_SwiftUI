//
//  NewTaskView.swift
//  ToDoApp_SwiftUI
//
//  Created by IkkiKobayashi on 2021/02/25.
//

import SwiftUI

struct NewTaskView: View {
    
    @State var task: String = ""
    @State var time: Date? = Date()
    @State var category: Int16 = ToDoEntity.Category.routine.rawValue
    var categories: [ToDoEntity.Category] = [.routine, .shopping, .healthCare]
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    // TODO: あとでExtensionに移す
    fileprivate func save() {
        do {
            try self.viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("タスク")) {
                    TextField("タスクを入力してください", text: $task)
                }
                
                Section(header: Toggle(isOn: Binding(isNotNil: $time, defaultValue: Date())) {
                    Text("予定時間")
                }) {
                    if isDateExist(date: time) {
                        DatePicker(selection: Binding(source: $time, defaultValue: Date()), label: { Text("日時") })
                    } else {
                        Text("not time setting")
                    }
                }
                
                Section(header: Text("カテゴリ")) {
                    Picker(selection: $category, label: Text("")) {
                        ForEach(categories, id: \.self) { category in
                            HStack {
                                CategoryImage(category: category)
                                Text(category.name)
                            }.tag(category.rawValue)
                        }
                    }
                }
                
                Section(header: Text("この画面を閉じる")) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(alignment: .center) {
                            Image(systemName: "minus.circle.fill")
                            Text("Cancel")
                        }.foregroundColor(.red)
                    }
                }
            }.navigationTitle("タスクの新規追加")
            .foregroundColor(Color("label"))
            .navigationBarItems(leading: Button(action: {
                ToDoEntity.create(in: viewContext,
                                  category: ToDoEntity.Category(rawValue: self.category) ?? .routine,
                                  task: self.task,
                                  time: self.time)
                self.save()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("保存")
                    .foregroundColor(Color("label"))
                
            })
        }
    }
}

private func isDateExist(date: Date?) -> Bool {
    return date != nil
}

struct NewTaskView_Previews: PreviewProvider {
    static let context = PersistenceController.shared.container.viewContext
    static var previews: some View {
        NewTaskView().environment(\.managedObjectContext, context)
    }
}
