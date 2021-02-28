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
    @State var showingSheet = false
    @State var showingAlert = false
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
                
                Section(header: Text("タスクを追加")) {
                    Button(action: {
                        if task == "" {
                            self.showingAlert = true
                            return
                        }
                        self.showingSheet = true
                    }) {
                        HStack(alignment: .center) {
                            Image(systemName: "pencil.circle.fill")
                            Text("Create")
                        }
                    }.alert(isPresented: $showingAlert) {
                        Alert(title: Text("タスクが入力されていません"),
                              message: Text("タスクの内容を入力してください"),
                              dismissButton: .default(Text("OK")))
                    }
                }
            }.navigationTitle("タスクの新規追加")
            .foregroundColor(Color("label"))
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("閉じる")
                    .foregroundColor(Color("label"))
            })
            .actionSheet(isPresented: $showingSheet) {
                ActionSheet(title: Text("タスクの追加"), message: Text("このタスクを追加します。よろしいですか？"), buttons: [
                    .destructive(Text("追加")) {
                        ToDoEntity.create(in: viewContext,
                                          category: ToDoEntity.Category(rawValue: self.category) ?? .routine,
                                          task: self.task,
                                          time: self.time)
                        self.save()
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    .cancel(Text("キャンセル"))
                ])
            }
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
