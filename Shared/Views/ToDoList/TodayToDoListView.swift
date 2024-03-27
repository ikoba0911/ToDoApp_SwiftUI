//
//  TodayTodoListView.swift
//  ToDoApp_SwiftUI (iOS)
//
//  Created by IkkiKobayashi on 2021/02/26.
//

import SwiftUI

struct TodayTaskListView: View {
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ToDoEntity.time,
                                                     ascending: true)],
                  predicate: NSPredicate(format: "time BETWEEN {%@ , %@}", Date.today as NSDate, Date.tomorrow as NSDate),
                  animation: .default) var todoList: FetchedResults<ToDoEntity>
    
    // MARK: - View
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("TodayToDoListViewTitle".localized)
                .font(.footnote)
                .bold()
                .padding()
            List(todoList) { todo in
                TodoDetailCell(todo: todo)
            }
        }.background(Color(UIColor.systemBackground))
        .clipShape(RoundedCorners(tl: 40, tr: 40, bl: 0, br: 0))
    }
}

#Preview {
    TodayTaskListView().environment(
        \.managedObjectContext,
         DeveloperToolsSupport.Preview.context
    )
}
