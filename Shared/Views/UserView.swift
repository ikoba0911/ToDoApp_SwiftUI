//
//  UserView.swift
//  ToDoApp_SwiftUI (iOS)
//
//  Created by IkkiKobayashi on 2021/02/18.
//

import SwiftUI

struct UserView: View {
    
    // MARK: - Property
    private let image: Image
    private let userName: String
    
    // MARK: - Init
    internal init(
        image: Image,
        userName: String
    ) {
        self.image = image
        self.userName = userName
    }
    
    // MARK: - View
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hello".localized)
                    .foregroundColor(Color.white)
                    .font(.footnote)
                Text(String(format: "UserName".localized,
                            userName))
                    .foregroundColor(Color.white)
                    .font(.title)
            }
            Spacer()
            image
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
        }
        .padding()
        .background(Color.green)
    }
}

#Preview("UserView") {
    UserView(
        image: Image("swift"),
        userName: "SwiftToDo"
    )
}

