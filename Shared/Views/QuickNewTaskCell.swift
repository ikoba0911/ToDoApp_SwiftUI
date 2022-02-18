//
//  QuickNewTaskCell.swift
//  ToDoApp_SwiftUI (iOS)
//
//  Created by IkkiKobayashi on 2021/02/20.
//

import SwiftUI

struct QuickNewTaskCell: View {
    
    // MARK: - Property
    let category: ToDoEntity.Category
    @State private var newTaskText: String = ""
    @Environment(\.managedObjectContext) var viewContext
    
    // MARK: - View
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

// MARK: - Function
extension QuickNewTaskCell {
    
    private func addNewTask() {
        guard newTaskText != "" else {
            return
        }
        ToDoEntity.create(in: self.viewContext, category: self.category, task: self.newTaskText)
        self.newTaskText = ""
    }
    
    private func cancelTask() {
        self.newTaskText = ""
        UIApplication.shared.closeKeyboard()
    }
}

#if DEBUG
struct QuickNewTaskCell_Previews: PreviewProvider {
    static let context = PersistenceController.shared.container.viewContext
    static var previews: some View {
        QuickNewTaskCell(category: .routine)
            .environment(\.managedObjectContext, self.context)
    }
}
#endif
