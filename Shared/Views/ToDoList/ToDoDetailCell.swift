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
        let context = PersistenceController.shared.container.viewContext
        
        let routineEntity = ToDoEntity.createDemoEntity(in: context,
                                                   category: .routine,
                                                   task: "勉強する",
                                                   state: .done)
        let shoppingentity = ToDoEntity.createDemoEntity(in: context,
                                                   category: .shopping,
                                                   task: "牛乳を買う",
                                                   state: .done)
        
        let healthCareentity = ToDoEntity.createDemoEntity(in: context,
                                                   category: .healthCare,
                                                   task: "ランニングをする",
                                                   state: .todo)
        let entities = [routineEntity, shoppingentity, healthCareentity]
        
        return VStack(alignment: .leading) {
            ForEach(entities, id: \.self) { entity in
                TodoDetailCell(todo: entity)
            }
            TodoDetailCell(todo: routineEntity, hideIcon: true)
        }
    }
}
#endif
