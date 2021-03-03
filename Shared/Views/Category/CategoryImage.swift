//
//  CategoryImage.swift
//  ToDoApp_SwiftUI (iOS)
//
//  Created by IkkiKobayashi on 2021/02/18.
//

import SwiftUI

struct CategoryImage: View {
    
    var category: ToDoEntity.Category
    
    init(category: ToDoEntity.Category?) {
        self.category = category ?? .routine
    }
    
    var body: some View {
        Image(systemName: category.imageName)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .padding(2.0)
                    .frame(width: 30, height: 30)
            .background(category.color)
                    .cornerRadius(6.0)
    }
}

#if DEBUG
struct CategoryImage_Previews: PreviewProvider {
    static var previews: some View {
        CategoryImage(category: .routine)
    }
}
#endif
