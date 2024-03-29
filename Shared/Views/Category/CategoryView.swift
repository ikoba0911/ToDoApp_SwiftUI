//
//  CategoryView.swift
//  ToDoApp_SwiftUI (iOS)
//
//  Created by IkkiKobayashi on 2021/02/18.
//

import SwiftUI

struct CategoryView: View {
    var category: ToDoEntity.Category
    @State private var numberOfTasks = 0
    @State private var showList = false
    @State private var addNewTask = false
    
    @Environment(\.managedObjectContext) var viewContext
    
    fileprivate func updateCount() {
        self.numberOfTasks = ToDoEntity.getTaskCount(in: self.viewContext, category: self.category)
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
                    ToDoListView(category: self.category)
                        .environment(\.managedObjectContext, self.viewContext)
                }
            Text(category.name)
            Text(String(format: "TaskRemainigCount".localized, numberOfTasks))
            
            Button(action: {
                self.addNewTask = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("AddTask".localized)
                }.padding()
                .border(Color.white, width: 3)
            }.sheet(isPresented: $addNewTask, onDismiss: {
                self.updateCount()
            }) {
                NewTaskView(category: self.category.rawValue)
                    .environment(\.managedObjectContext, self.viewContext)
            }
        }.padding()
        .frame(maxWidth: .infinity, minHeight: 150)
        .foregroundColor(.white)
        .background(linearGradient)
        .cornerRadius(40)
        .onTapGesture {
            self.showList = true
        }
        .onAppear {
            updateCount()
        }
    }
}

#Preview("routine") {
    CategoryView(
        category: .routine
    ).padding()
        .environment(\.managedObjectContext, DeveloperToolsSupport.Preview.context)
}

#Preview("healthCare") {
    CategoryView(
        category: .healthCare
    ).padding()
        .environment(\.managedObjectContext, DeveloperToolsSupport.Preview.context)
}

#Preview("shopping") {
    CategoryView(
        category: .shopping
    ).padding()
        .environment(\.managedObjectContext, DeveloperToolsSupport.Preview.context)
}

