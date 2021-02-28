//
//  ContentView.swift
//  Shared
//
//  Created by IkkiKobayashi on 2021/02/15.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        VStack(spacing: 0) {
            // topのセーフゾーン対策
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 0)
            
            UserView(image: Image("swift"), userName: "ToDoApp")
            Spacer()
            
            CategoryView(category: .routine).padding()
            HStack(spacing: 0) {
                CategoryView(category: .shopping)
                Spacer()
                CategoryView(category: .healthCare)
            }.padding()
            
            TodayTaskListView()
            
        }.background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.bottom)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static let context = PersistenceController.shared.container.viewContext
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, context)
    }
}
#endif
