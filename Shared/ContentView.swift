//
//  ContentView.swift
//  Shared
//
//  Created by IkkiKobayashi on 2021/02/15.
//

import SwiftUI

struct ContentView: View {

    // MARK: - View
    var body: some View {
        VStack(spacing: 0) {
            // Measures for top safe zones
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

#Preview("ContentView") {
    ContentView().environment(
        \.managedObjectContext,
         DeveloperToolsSupport.Preview.context
    )
}
