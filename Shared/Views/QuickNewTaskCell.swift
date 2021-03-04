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
        guard newTaskText != "" else {
            return
        }
        ToDoEntity.create(in: self.viewContext, category: self.category, task: self.newTaskText)
        self.newTaskText = ""
    }
    
    fileprivate func cancelTask() {
        self.newTaskText = ""
        UIApplication.shared.closeKeyboard()
    }
    
    var body: some View {
        HStack {
            TextField("InputTask".localized, text: $newTaskText, onCommit:  {
                self.addNewTask()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .foregroundColor(Color("label"))
            
            Button(action: {
                self.addNewTask()
            }) {
                Text("Add".localized)
                    .foregroundColor(Color("label"))
            }
            Button(action: {
                self.cancelTask()
            }) {
                Text("Cancel".localized)
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
