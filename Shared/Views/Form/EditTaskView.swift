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
            Section(header: Text("タスク")) {
                TextField("タスクを入力", text: Binding(source: $todo.task,defaultValue: ""))
            }
            
            Section(header: Toggle(isOn: Binding(isNotNil: $todo.time, defaultValue: Date())){Text("時間を指定する")}) {
                if todo.time != nil {
                    DatePicker(selection: Binding(source: $todo.time, defaultValue: Date()), label: { Text("日時") })
                } else {
                    Text("時間未設定").foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("カテゴリ")) {
                Picker(selection: $todo.category, label: Text("")) {
                    ForEach(categories, id: \.self) { category in
                        HStack {
                            CategoryImage(category: category)
                            Text(category.name)
                        }.tag(category.rawValue)
                    }
                }
            }
            
            Section(header: Text("タスクを削除する")) {
                Button(action: {
                    self.showingSheet = true
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: "minus.circle.fill")
                        Text("Delete")
                    }.foregroundColor(.red)
                }
            }
        }.navigationBarTitle("タスクの編集")
            .navigationBarItems(trailing: Button(action: {
                self.save()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("閉じる")
            })
            .actionSheet(isPresented: $showingSheet) {
                ActionSheet(title: Text("タスクの削除"), message: Text("このタスクを削除します。よろしいですか？"), buttons: [
                    .destructive(Text("削除")) {
                        self.delete()
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    .cancel(Text("キャンセル"))
                
                ])
        }
    }
}

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
