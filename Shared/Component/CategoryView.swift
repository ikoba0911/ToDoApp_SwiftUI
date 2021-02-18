//
//  CategoryView.swift
//  ToDoApp_SwiftUI (iOS)
//
//  Created by IkkiKobayashi on 2021/02/18.
//

import SwiftUI

struct CategoryView: View {
    var category: TodoEntity.Category
    @State var numberOfTasks = 0
    @State var showList = false
    @State var addNewtask = false
    
    @Environment(\.managedObjectContext) var viewContext
    
    fileprivate func updateCount() {
        // 表示された時
        self.numberOfTasks = TodoEntity.getTaskCount(in: self.viewContext, category: self.category)
    }
    
    var body: some View {
        
        let gradient = Gradient(colors: [category.color,
                                                 category.color.opacity(0.8)])
        let linearGradient = LinearGradient(gradient: gradient,
                                            startPoint: .top,
                                            endPoint: .bottom)
        
        
        VStack(alignment: .leading) {
            Image(systemName: category.imageName)
                .font(.largeTitle)
                .sheet(isPresented: $showList, onDismiss: {
                        self.updateCount() }
                ) {
                    // TODO: 該当のカテゴリのタスク一覧へ遷移する
                }
            Text(category.name)
            Text("残\(numberOfTasks)個")
            
            Button(action: {
                self.addNewtask = true
            }) {
                Image(systemName: "plus")
            }.sheet(isPresented: $addNewtask, onDismiss: {
                self.updateCount()
            }) {
                // TODO: タスクを追加するためのViewへ遷移する
            }
        }.padding()
        .frame(maxWidth: .infinity, minHeight: 150)
        .cornerRadius(20)
        .foregroundColor(.white)
        .background(linearGradient)
        .onTapGesture { // タップされた時
            self.showList = true
        }
        .onAppear {
            updateCount()
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static let context = PersistenceController.shared.container.viewContext
    
    static var previews: some View {
        VStack {
            CategoryView(category: .routine).padding()
            CategoryView(category: .shopping).padding()
            CategoryView(category: .healthCare).padding()
        }.environment(\.managedObjectContext, context)
    }
}
