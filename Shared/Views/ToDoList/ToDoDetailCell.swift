//
//  ToDoDetailCell.swift
//  ToDoApp_SwiftUI (iOS)
//
//  Created by IkkiKobayashi on 2021/02/21.
//

import SwiftUI

struct TodoDetailCell: View {
    
    // MARK: - Property
    @ObservedObject var todo: ToDoEntity
    private let doneState: Int16 = ToDoEntity.State.done.rawValue
    private let uncompletedState: Int16 = ToDoEntity.State.todo.rawValue
    // unused property
    var hideIcon = false
    
    // MARK: - View
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

// MARK: - Function
extension TodoDetailCell {
    
    private func isCompleted(state: Int16) -> Bool {
        return state == ToDoEntity.State.done.rawValue
    }
}

#Preview("study") {
    let routineEntity = ToDoEntity.createDemoEntity(in: DeveloperToolsSupport.Preview.context,
                                               category: .routine,
                                               task: "勉強する",
                                               state: .done)
    return TodoDetailCell(todo: routineEntity)
}

#Preview("shopping") {
    let shoppingEntity = ToDoEntity.createDemoEntity(in: DeveloperToolsSupport.Preview.context,
                                               category: .shopping,
                                               task: "牛乳を買う",
                                               state: .done)
    return TodoDetailCell(todo: shoppingEntity)
}

#Preview("shopping") {
    let healthCareEntity = ToDoEntity.createDemoEntity(in: DeveloperToolsSupport.Preview.context,
                                               category: .healthCare,
                                               task: "ランニングをする",
                                               state: .todo)
    return TodoDetailCell(todo: healthCareEntity)
}

#Preview("all") {
    let context = DeveloperToolsSupport.Preview.context
    
    let routineEntity = ToDoEntity.createDemoEntity(in: context,
                                               category: .routine,
                                               task: "勉強する",
                                               state: .done)
    let shoppingEntity = ToDoEntity.createDemoEntity(in: context,
                                               category: .shopping,
                                               task: "牛乳を買う",
                                               state: .done)
    
    let healthCareEntity = ToDoEntity.createDemoEntity(in: context,
                                               category: .healthCare,
                                               task: "ランニングをする",
                                               state: .todo)
    let entities = [
        routineEntity,
        shoppingEntity,
        healthCareEntity
    ]
    
    return VStack(alignment: .leading) {
        ForEach(entities, id: \.self) { entity in
            TodoDetailCell(todo: entity)
        }
        TodoDetailCell(todo: routineEntity, hideIcon: true)
    }
}
