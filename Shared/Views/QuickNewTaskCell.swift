//
//  QuickNewTaskCell.swift
//  ToDoApp_SwiftUI (iOS)
//
//  Created by IkkiKobayashi on 2021/02/20.
//

import SwiftUI

struct QuickNewTaskCell: View {
    
    let category: ToDoEntity.Category
    @State var newTaskText: String = ""
    @Environment(\.managedObjectContext) var viewContext
    
    fileprivate func addNewTask() {
        ToDoEntity.create(in: self.viewContext, category: self.category, task: self.newTaskText)
        self.newTaskText = ""
    }
    
    fileprivate func cancelTask() {
        self.newTaskText = ""
    }
    
    var body: some View {
        HStack {
            TextField("新しいタスク", text: $newTaskText, onCommit:  {
                self.addNewTask()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .foregroundColor(Color("label"))
            
            Button(action: {
                self.addNewTask()
            }) {
                Text("追加")
                    .foregroundColor(Color("label"))
            }
            Button(action: {
                self.cancelTask()
            }) {
                Text("キャンセル")
                    .foregroundColor(.red)
            }
        }
    }
}

#if DEBUG
struct QuickNewTaskCell_Previews: PreviewProvider {
    static let context = PersistenceController.shared.container.viewContext
    static var previews: some View {
        QuickNewTaskCell(category: .routine).environment(\.managedObjectContext, self.context)
    }
}
#endif
