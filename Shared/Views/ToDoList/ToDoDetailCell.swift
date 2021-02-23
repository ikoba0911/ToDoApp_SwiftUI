//
//  ToDoDetailCell.swift
//  ToDoApp_SwiftUI (iOS)
//
//  Created by IkkiKobayashi on 2021/02/21.
//

import SwiftUI

struct TodoDetailCell: View {
    
    @ObservedObject var todo: ToDoEntity
    let doneState: Int16 = ToDoEntity.State.done.rawValue
    let uncompletedState: Int16 = ToDoEntity.State.todo.rawValue
    var hideIcon = false
    
    var body: some View {
        HStack {
            if !hideIcon {
                CategoryImage(category: ToDoEntity.Category(rawValue: todo.category))
            }
            CheckBox(checked: Binding(get: {
                isCompleted(state: self.todo.state)
            }, set: {
                self.todo.state = $0 ? doneState :uncompletedState
            })) {
                if isCompleted(state: self.todo.state) {
                    Text(self.todo.task ?? "no title").strikethrough()
                } else {
                    Text(self.todo.task ?? "no title")
                }
            }.foregroundColor(isCompleted(state: self.todo.state) ? .secondary : .primary)
        }.gesture(DragGesture().onChanged({ value in
            if value.predictedEndTranslation.width > 200 {
                if !isCompleted(state: self.todo.state) {
                    self.todo.state = doneState
                }
            } else if value.predictedEndTranslation.width < -200 {
                if isCompleted(state: self.todo.state) {
                    self.todo.state = uncompletedState
                }
            }
        }))
    }
}

private func isCompleted(state: Int16) -> Bool {
    return state == ToDoEntity.State.done.rawValue
}

#if DEBUG
struct TodoDetailCell_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let doneState: Int16 = ToDoEntity.State.done.rawValue
        let uncompletedState: Int16 = ToDoEntity.State.todo.rawValue
        
        let container = PersistenceController.shared.container
        let context = container.viewContext
        
        let newTask1 = ToDoEntity(context: context)
        newTask1.task = "勉強する"
        newTask1.state = doneState
        newTask1.category = 0
        
        let newTask2 = ToDoEntity(context: context)
        newTask2.task = "牛乳を買う"
        newTask2.state = doneState
        newTask2.category = 1
        
        let newTask3 = ToDoEntity(context: context)
        newTask3.task = "ランニングをする"
        newTask3.state = uncompletedState
        newTask3.category = 2
        
        return VStack(alignment: .leading) {
            TodoDetailCell(todo: newTask1)
            TodoDetailCell(todo: newTask1, hideIcon: true)
            TodoDetailCell(todo: newTask2)
            TodoDetailCell(todo: newTask3)
        }
    }
}
#endif
